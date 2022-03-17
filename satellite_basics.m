%Create satellite scenario
startTime = datetime(2020,5,12,13,0,0);
stopTime = startTime + hours(6);
sampleTime = 30; %seconds
sc = satelliteScenario(startTime, stopTime, sampleTime);

% Add satellite to satellite scenario
tleFile = "leoSatelliteConstellation.tle"; % determines the mean orbital parameter of 40 generic satellites in circular low-earth orbits
sat = satellite(sc,tleFile); %add satellite

% Add Cameras to the Satellite
names = sat.Name + " Camera";
cam = conicalSensor(sat, "Name", names, "MaxViewAngle", 90); %conical sensors respresent cameras, max view angle defines the field of view

% Define geographical site to be photographed in satellite scenario
name = "Geographical Site to be photographed";
minElevationAngle = 30; %degrees
geoSite = groundStation(sc,42.4,-70.35, "Name", name, "MinElevationAngle", minElevationAngle);

% Add access analysis between cameras and geographical site
ac = access(cam, geoSite); % access analysis between camera and geographical site, determines when camera can photograph the site
ac(1) %property of access analysis object (linewidth : 1)

%Visualize the scenario
v = satelliteScenarioViewer(sc, "ShowDetails", false); % Hide orbits and labels of satellites ad grround stations
sat(4).ShowLabel = true; % show label for satellite 4
geoSite.ShowLabel = true; % show label of geographical site
show(sat(4));

%Visualize the field of view of the camera
fov = fieldOfView(cam([cam.Name] == "Satellite 4 Camera"));% visualize field of view of each camera on satellite 4
ac.LineColor = 'green';

%Determine times when cameras can photograph geographical satellite
accessIntervals(ac)


% Calculate system-wide access percentage

for idx = 1:numel(ac)
    [s, timeofday] = accessStatus(ac(idx));
    
    if idx == 1
        % Initialize system-wide access status vector in first iteration
        systemWideAccessStatus = s;
    else
        % Update system-wide access status vector by performing logical OR
        % with access status for the current camera-site access analysis
        systemWideAccessStatus = or(systemWideAccessStatus, s);
    end
end

% Plot to plot system-wide access with respect to time

plot(timeofday,systemWideAccessStatus);
grid on;
xlabel("Time");
ylabel("System-Wide Access Status")


% Determine number of elements whose systemWideAccessStatus is set to be
% True
n = nnz(systemWideAccessStatus) %non zero elements 


%Total time when at least one camera can photograph the site
systemWideAccessDuration = n * sc.SampleTime; % seconds

%Calculate total scenario duration
scenarioDuration = seconds(sc.StopTime - sc.StartTime);

systemWideAccessPercentage = (systemWideAccessDuration/scenarioDuration) * 100;



