%% create MPC controller object with sample time
mpc1 = mpc(plant_1_C, 1);
%% specify prediction horizon
mpc1.PredictionHorizon = 10;
%% specify control horizon
mpc1.ControlHorizon = 2;
%% specify nominal values for inputs and outputs
mpc1.Model.Nominal.U = [0;0;0.05];
mpc1.Model.Nominal.Y = [42;50];
%% specify constraints for MV and MV Rate
mpc1.MV(1).Min = 0;
mpc1.MV(1).Max = 400;
mpc1.MV(1).RateMax = 14;
mpc1.MV(2).Min = 0;
mpc1.MV(2).Max = 680;
mpc1.MV(2).RateMax = 24;
%% specify overall adjustment factor applied to weights
beta = 12;
%% specify weights
mpc1.Weights.MV = [0 0]*beta;
mpc1.Weights.MVRate = [0.1 0.1]/beta;
mpc1.Weights.OV = [50 100]*beta;
mpc1.Weights.ECR = 100000;
%% specify overall adjustment factor applied to estimation model gains
alpha = 1;
%% adjust default output disturbance model gains
setoutdist(mpc1, 'model', getoutdist(mpc1)*alpha);
%% adjust default measurement noise model gains
mpc1.Model.Noise = mpc1.Model.Noise/alpha;
%% specify simulation options
options = mpcsimopt();
options.RefLookAhead = 'off';
options.MDLookAhead = 'off';
options.Constraints = 'on';
options.OpenLoop = 'off';
%% run simulation
sim(mpc1, 11, mpc1_RefSignal, mpc1_MDSignal, options);
