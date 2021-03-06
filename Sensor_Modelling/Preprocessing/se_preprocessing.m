% This preprocesses the HYG Database as per the requirements
%   This script loads se_magnitude_limit from se_Variables.mat in the
%   Parent Directory. Then, only StarID, RA, Dec, Mag, and Distance columns
%   are reatined. Finally, only stars with Magnitude value less than
%   se_magnitude_limit are retained. The final Pre-procesed catalogue is
%   saved in the parent directory under the name Simulation_HYG.csv

%% Load Variables
% Load 'se_magnitude_limit' and 'se_debug_run' from 'se_variables.mat'
load('se_variables.mat', 'se_magnitude_limit', 'se_debug_run');


%% Read the Catalogue
% Read the SKY 2000 SSP_Star_Catalogue.csv into the table SKY2000
SKY2000 = readtable('SSP_Star_Catalogue.csv');
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Read'); end

% Remove the following columns - 'SKY2000_ID', 'B_V'
SKY2000 = removevars(SKY2000,{'SKY2000_ID', 'B_V'});
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Trimmed'); end

%% Trim Catalogue according to Star Magnitude
% Copy the stars with Magnitude less than se_magnitude_limit to se_T
se_T = SKY2000(SKY2000.Vmag <= se_magnitude_limit, :);
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Modified'); end

%% Rename Column Headers
% Renaming all headers
se_T.Properties.VariableNames{'DE'} = 'Dec';
se_T.Properties.VariableNames{'pmRA'} = 'pm_RA';
se_T.Properties.VariableNames{'pmDE'} = 'pm_Dec';
se_T.Properties.VariableNames{'Vmag'} = 'Magnitude';

%% Add Unit Vectors of all Stars
% Add Columns x0, y0, z0 (Cartesian coordinates) of the stars in ICRS frame
% to the table using the RA, Dec, Roll fields (Independent of Boresight 
% Input)
% se_T.x0 = + cosd(se_T.Dec) .* cosd(se_T.RA);
% se_T.y0 = + cosd(se_T.Dec) .* sind(se_T.RA);
% se_T.z0 = + sind(se_T.Dec);
se_T.r0 = [cosd(se_T.Dec) .* cosd(se_T.RA), cosd(se_T.Dec) .* sind(se_T.RA), sind(se_T.Dec)];
% Display Sucess
if (se_debug_run == 1); disp('Preprocessing: Succesfully Converted to Cartesian Coordinates'); end

% Remove sun from the database % Deleting Rows
% Simulation_HYG([1],:) = [];

%% Save Star Catalogue
% Store a copy of the SKY2000 table into '../se_SKY2000.mat' and
% '../se_SKY2000.csv'
save('./Sensor_Modelling/Processing/se_SKY2000.mat', 'se_T');
if (se_debug_run == 1); writetable(se_T, './Sensor_Modelling/Processing/se_SKY2000.csv'); end
if (se_debug_run == 1); disp('Preprocessing: Modified Catalogue Successfully Saved'); end

% Clear Preprocessing variables from workspace
if (se_debug_run == 1); clear('se_SKY2000', 'SKY2000'); end

% Display Sucess
fprintf('Preprocessing: Success \n \n');


