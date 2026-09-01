from statsmodels.tsa.stattools import adfuller
from statsmodels.tsa.ar_model import AutoReg
from statsmodels.stats.diagnostic import acorr_ljungbox
from statsmodels.stats.stattools import jarque_bera

import pandas as pd
import numpy as np
import warnings

warnings.filterwarnings("ignore")


# =========================
# 文件路径
# =========================

# 协和
file_path = 'AAAAA协和_EMO-rec.csv'

start_date = None
end_date = None

save_prefix = "xiehe_"


# =========================
# 参数设置
# =========================

freq = '6h'      # 时间聚合粒度
maxlag = 8       # 最大AR阶数


# =========================
# 读取数据
# =========================

df = pd.read_csv(file_path)

df['发帖时间'] = pd.to_datetime(df['发帖时间'])


# =========================
# 时间截断
# =========================

if start_date:
    df = df[df['发帖时间'] >= pd.to_datetime(start_date)]

if end_date:
    df = df[df['发帖时间'] <= pd.to_datetime(end_date)]

df = df.sort_values('发帖时间').reset_index(drop=True)

print(f"时间截断后样本量：{len(df)}")


# =========================
# 自动差分直到平稳
# =========================

def difference_to_stationary(series, max_d=3):

    s = series.copy()
    d = 0

    while d < max_d:

        if len(s.dropna()) < 10:
            break

        adf_p = adfuller(s.dropna())[1]

        if adf_p < 0.05:
            return s.dropna(), d

        s = s.diff()
        d += 1

    return s.dropna(), d


# =========================
# AR分析函数
# =========================

def run_ar_analysis(data):

    print(f"\n{'=' * 60}")
    print("开始 AR 时间序列分析")
    print(f"{'=' * 60}")

    data = data.copy()

    # =========================
    # moral outrage变量
    # =========================

    data['is_moral'] = (
        data['EMO'].isin([1, 4, 7]).astype(int)
    )

    # =========================
    # 聚合时间序列
    # =========================

    moral_ts = data.resample(
        freq,
        on='发帖时间'
    )['is_moral'].mean()

    moral_ts = moral_ts.fillna(0)

    print("\n原始时间序列：")
    print(moral_ts.head())

    print(f"\n时间序列长度: {len(moral_ts)}")

    # =========================
    # 平稳化处理
    # =========================

    moral_ts_stationary, d = difference_to_stationary(
        moral_ts
    )

    print(f"\nADF平稳化差分阶数: {d}")

    adf_result = adfuller(
        moral_ts_stationary
    )

    print(f"ADF statistic: {adf_result[0]:.4f}")
    print(f"ADF p-value: {adf_result[1]:.6f}")

    # =========================
    # AIC自动选阶
    # =========================

    best_aic = np.inf
    best_lag = None
    best_model = None

    print("\n开始AIC自动选阶：")

    for lag in range(1, maxlag + 1):

        try:

            model = AutoReg(
                moral_ts_stationary,
                lags=lag,
                old_names=False
            ).fit()

            print(
                f"AR({lag}) AIC = {model.aic:.3f}"
            )

            if model.aic < best_aic:

                best_aic = model.aic
                best_lag = lag
                best_model = model

        except Exception as e:

            print(
                f"AR({lag}) 拟合失败：{e}"
            )

            continue

    # =========================
    # 输出最佳模型
    # =========================

    if best_model is None:

        print("AR模型拟合失败")
        return

    print(f"\n最佳AR阶数: {best_lag}")
    print(f"最佳AIC: {best_aic:.3f}")

    # =========================
    # AR模型结果
    # =========================

    print("\nAR模型结果：")

    print(best_model.summary())

    # =========================
    # 提取残差
    # =========================

    resid = best_model.resid

    # =========================
    # Ljung-Box检验
    # =========================

    print("\nLjung-Box 残差白噪声检验")

    lb_result = acorr_ljungbox(
        resid,
        lags=[best_lag],
        return_df=True
    )

    print(lb_result)

    # =========================
    # Jarque-Bera检验
    # =========================

    print("\nJarque-Bera 正态性检验")

    jb_stat, jb_p, skew, kurt = jarque_bera(
        resid
    )

    print(f"JB statistic: {jb_stat:.4f}")
    print(f"JB p-value: {jb_p:.6f}")
    print(f"Skewness: {skew:.4f}")
    print(f"Kurtosis: {kurt:.4f}")


# =========================
# 执行分析
# =========================

run_ar_analysis(df)
