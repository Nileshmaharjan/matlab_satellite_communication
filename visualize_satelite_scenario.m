% Create satellite scenario

startTime = datetime(2022,1,31,08,23,0);
stopTime = startTime + hours(5);
sampleTime = 60; %seconds
sc = satelliteScenario(startTime, stopTime, sampleTime);

% Add Satellites to the Scenario
sat = satellite(sc, "threeSatelliteConstellation.tle" );
show(sat) % Show the satellites in orbit
groundTrack(sat, "LeadTime" ,1200); %  plot their ground tracks over 20 minutes.

% Return Orbital Elements and Position of the Satellites
ele1 = orbitalElements(sat(1));
ele2 = orbitalElements(sat(2));
ele3 = orbitalElements(sat(3));

% Return the latitude, longitude, and altitude of the first satellite at time 31-Jan-2022 12:30:00 PM UTC.
time = datetime(2022,1,31,12,30,0);
pos = states(sat(1),time, "CoordinateFrame" , "geographic" );

% Add the Madrid and Canberra Deep Space Communications Complexes as the ground stations of interest, and specify their latitudes and longitudes.
name = [ "Madrid Deep Space Communications Complex" ,"Canberra Deep Space Communications Complex" ];
lat = [40.43139, -35.40139];
lon = [-4.24806, 148.98167];
gs = groundStation(sc, "Name" ,name, "Latitude" ,lat, "Longitude" , lon);

% Return Azimuth Angle, Elevation Angle, and Range at a Specified Time
time = datetime(2022,1,31,12,30,0);
[az,elev,r] = aer(gs(1),sat(1),time)

play(sc)