%% Use to interpolate pool data with uniform sampling
%% Apr 2024 Su Ki Ooi

%load data from pool

clear all

load Pool  %% The data is non uniformly sampled.

%% Interpolate the data with uniform sampling
T = 1; % uniform sampling in minute

%% Interpolate with uniform sampling

% Create a time vector with a uniform sampling T
POOL_REG_USL_VALi{:,1} = POOL_REG_USL_VAL{1,1}:minutes(T):POOL_REG_USL_VAL{end,1};

POOL_REG_GATE_ELEVATIONi{:,1} = POOL_REG_USL_VALi{:,1}; % fix the timestamp to be the same

POOL_REG_FLOW_VALi{:,1} = POOL_REG_USL_VALi{:,1}; % fix the timestamp to be the same

% Linearly interpolate the data to match the new time vector
% U/S Level
POOL_REG_USL_VALi{:,2} = interp1(POOL_REG_USL_VAL{:,1}, POOL_REG_USL_VAL{:,2}, POOL_REG_USL_VALi{:,1});

% Gate elevations
POOL_REG_GATE_ELEVATIONi{:,2} = interp1(POOL_REG_GATE_ELEVATION{:,1}, POOL_REG_GATE_ELEVATION{:,2}, POOL_REG_GATE_ELEVATIONi{:,1});

% Flow
POOL_REG_FLOW_VALi{:,2} = interp1(POOL_REG_FLOW_VAL{:,1}, POOL_REG_FLOW_VAL{:,2}, POOL_REG_FLOW_VALi{:,1});

