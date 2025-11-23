clear, clc, close all


n_trials_per_wv = 20;
short_colour = [0 0 1]; % blue
medium_colour = [0 1 0]; % green
long_colour = [1 0 0]; % red
bg_color = [1 1 1]; % background color
original_circle_size = 120;


% list of sizes relative to target
sizes = [1.05 1.07 1.10 1.13 1.15 1.17 1.20 1.23 1.25 1.27 1.30 1.33 1.35 1.37 1.40 1.43 1.45 1.47 1.50 1.55 ];


% initialize correct array (with pre determined left/rights)
correct_short = randi([1 2], 1, n_trials_per_wv);
correct_medium = randi([1 2], 1, n_trials_per_wv);
correct_long = randi([1 2], 1, n_trials_per_wv);

% initialize size array (of circles)
size_short = sizes(randperm(length(sizes))) * original_circle_size;
size_medium = sizes(randperm(length(sizes))) * original_circle_size;
size_long = sizes(randperm(length(sizes))) * original_circle_size;

% initialize response array
resp_short = nan(1, n_trials_per_wv);
resp_medium = nan(1, n_trials_per_wv);
resp_long = nan(1, n_trials_per_wv);



%%  beginning of trial
figure(1), clf, hold on

% Setup the figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1],'Toolbar', 'none', 'Menu', 'none','Color',bg_color) % Position is [hrz, vrt, height, width] 
set(gca, 'Color', bg_color, 'xlim', [-2 2], 'ylim', [-1 1])
axis off

% Create the two circles, but make them invisible (ie same tone as bg) before the trials start
left = plot(-1, 0, 'o', 'MarkerSize', original_circle_size, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_color); hold on
right = plot( 1, 0, 'o', 'MarkerSize', original_circle_size, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_color);

% Participant instructions
instructions = text(0,0,['Indicate which circle is larger by pressing 1 ' ...
    '(left) or 2 (right) on the keyboard. ' newline 'Press any key to ' ...
    'begin the trial'],'HorizontalAlignment', ...
    'center', 'FontSize',20, 'Color', [0 0 0]);

waitforbuttonpress
delete(instructions)

% Setup the random trial order
short_order = repmat('S',1,20); 
med_order = repmat('M',1, 20);
long_order = repmat('L',1,20);
wavelength_order = [short_order med_order long_order];
% Array of S,M,L characters to represent the order
trial_order = wavelength_order(randperm(length(wavelength_order)));

%% trial for short wavelength

% individual indices
s_counter=1;
m_counter=1;
l_counter=1;

% Experiment
for i = 1:length(trial_order)

    fix = text(0,0, '+', 'HorizontalAlignment','center','FontSize',50);

    if trial_order(i) == 'S'
        if correct_short(s_counter) == 1 % larger circle on left
            set(left,'MarkerFaceColor',short_colour, 'MarkerSize', size_short(s_counter))
            set(right,'MarkerFaceColor',short_colour,'MarkerSize', original_circle_size)
        else  % larger circle on right
            set(right,'MarkerFaceColor',short_colour, 'MarkerSize', size_short(s_counter))
            set(left,'MarkerFaceColor',short_colour, 'MarkerSize',original_circle_size)
        end

    elseif trial_order(i) == 'M'
        if correct_medium(m_counter) == 1 % left
            set(left,'MarkerFaceColor',medium_colour, 'MarkerSize', size_medium(m_counter))
            set(right,'MarkerFaceColor',medium_colour,'MarkerSize', original_circle_size)
        else % right
            set(right,'MarkerFaceColor',medium_colour, 'MarkerSize', size_medium(m_counter))
            set(left,'MarkerFaceColor',medium_colour, 'MarkerSize',original_circle_size)
        end

     elseif trial_order(i) == 'L'
        if correct_long(l_counter) == 1 % left
            set(left,'MarkerFaceColor',long_colour, 'MarkerSize', size_long(l_counter))
            set(right,'MarkerFaceColor',long_colour,'MarkerSize', original_circle_size)
        else % right
            set(right,'MarkerFaceColor',long_colour, 'MarkerSize', size_long(l_counter))
            set(left,'MarkerFaceColor',long_colour, 'MarkerSize',original_circle_size)
        end

    end
    
    pause(.5)
    set(left,'MarkerFaceColor',bg_color)
    set(right,'MarkerFaceColor',bg_color)
    delete(fix)

    % participant input
    pause(.3)
    input_text = text(0,0,'Which circle is larger? (1/2)','HorizontalAlignment','center', 'FontSize',20, 'Color', [0 0 0]);

    waitforbuttonpress

    input = str2double(get(gcf, 'CurrentCharacter'));
    
    if trial_order(i) == 'S'
        resp_short(s_counter) = input;
        s_counter = s_counter + 1;
    elseif trial_order(i) == 'M'
        resp_medium(m_counter) = input;
        m_counter = m_counter+1;
    elseif trial_order(i) == 'L'
        resp_long(l_counter) = input;
        l_counter = l_counter+1;
    end

    delete(input_text)
    
    pause(.5)
    clc
   
end


%% analysis for short
nH_short=0; % hit
nF_short=0; % false alarm

nH_medium=0;
nF_medium=0; 

nH_long=0;
nF_long=0; 

% iterate through trials and check if its correct
for j = 1:n_trials_per_wv

    % short trial: if target left & response is left
    if correct_short(j) == 1 && resp_short(j) == 1
        nH_short = nH_short + 1;
    elseif correct_short(j) == 2 && resp_short(j) == 2
        nH_short = nH_short +1;

   % short trial: if target is right & response is left
    elseif correct_short(j) == 2 && resp_short(j) == 1
        nF_short = nF_short+1;

    end

     % medium trial: if target left & response is left
    if correct_medium(j) == 1 && resp_medium(j) == 1
         nH_medium = nH_medium + 1;
        
    elseif correct_medium(j) == 2 && resp_medium(j) == 2
        nH_medium = nH_medium +1;

   % medium trial: if target is right & response is left
    elseif correct_medium(j) == 2 && resp_medium(j) == 1
        nF_medium = nF_medium+1;

    end

    % long trial: if target left & response is left
    if correct_long(j) == 1 && resp_long(j) == 1
        nH_long = nH_long + 1;

    elseif correct_long(j) == 2 && resp_long(j) == 2
        nH_long = nH_long +1;
   % long trial: if target is right & response is left
    elseif correct_long(j) == 2 && resp_long(j) == 1
        nF_long = nF_long+1;
    end
end

% create pH (proportion hit) and pF (proportion false alarm) values
pH_short = nH_short/n_trials_per_wv;
pF_short= nF_short/n_trials_per_wv;

pH_medium = nH_medium/n_trials_per_wv;
pF_medium= nF_medium/n_trials_per_wv;

pH_long = nH_long/n_trials_per_wv;
pF_long= nF_long/n_trials_per_wv;

% palamedes
palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';
addpath(palamedes_dir)

[dp_short, C_short, lnB_short, Pc_short] = PAL_SDT_1AFC_PHFtoDP([pH_short pF_short]);

[dp_medium, C_medium, lnB_medium, Pc_medium] = PAL_SDT_1AFC_PHFtoDP([pH_medium pF_medium]);

[dp_long, C_long, lnB_long, Pc_long] = PAL_SDT_1AFC_PHFtoDP([pH_long pF_long]);
