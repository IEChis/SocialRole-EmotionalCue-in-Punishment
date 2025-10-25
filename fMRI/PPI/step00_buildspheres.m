% This script loads MNI coordinates specified in a user-created file,
% spherelist.txt, and generates .mat and .img ROI files for use with
% Marsbar, MRIcron etc.  spherelist.txt should list the centres of
% desired spheres, one-per-row, with coordinates in the format:
% X1 Y1 Z1
% X2 Y2 Z2 etc
% .mat sphere ROIs will be saved in the script-created \mat\ directory.
% .img sphere ROIs will be saved in the script-created \img\ directory.
% SPM Toolbox Marsbar should be installed and started before running script.

% specify radius of spheres to build in mm
radiusmm = 6;

spherelist=load('spherelist_reg.txt');
ROInames=textread('labellist_reg.txt','%s');  %%�@names of each ROI;
% Specify Output Folders for two sets of images (.img format and .mat format)
%mkdir('img');
%mkdir('mat');
roi_dir_img = 'img';%'img/';
roi_dir_mat = 'mat';%'mat/';
% Make an img and an mat directory to save resulting ROIs

% Go through each set of coordinates from the specified file (line 2)
spherelistrows = length(spherelist(:,1));
for spherenumbers = 1:spherelistrows
% maximum is specified as the centre of the sphere in mm in MNI space
maximum = spherelist(spherenumbers,1:3);
sphere_centre = maximum;
sphere_radius = radiusmm;
sphere_roi = maroi_sphere(struct('centre', sphere_centre, ...
    'radius', sphere_radius));

% Define sphere name using coordinates
coordsx = num2str(maximum(1));
coordsy = num2str(maximum(2));
coordsz = num2str(maximum(3));
spherelabel = sprintf('%s_%s_%s', coordsx, coordsy, coordsz);
sphere_roi = label(sphere_roi, spherelabel);

nam=[num2str(radiusmm) 'mm_' ROInames{spherenumbers} '_roi.mat'];
% save ROI as MarsBaR ROI file
saveroi(sphere_roi, fullfile(roi_dir_mat, nam));
% Save as image
nam2=[num2str(radiusmm) 'mm_' ROInames{spherenumbers} '_roi.img'];
save_as_image(sphere_roi, fullfile(roi_dir_img, nam2));
end