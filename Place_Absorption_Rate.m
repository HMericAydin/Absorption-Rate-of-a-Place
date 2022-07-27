clear all
clc
%% AREAS AND VOLUME
fprintf('DETERMINE THE AREAS AND VOLUME \n');
N=input('the number of the step size of floor = ');
h=input('height of each step size (in meters) = ');
L=input('length of the classroom (in meters) = ');
H=input('height of the classroom (in meters) = ');
W=input('width of the classroom (in meters) = ');
S=input('first step size distance of the board (in meters) = ');
Windows_side1=input('Windows area of the one side floor (in m^2) = ');
Windows_side2=input('Windows area of the other side floor (in m^2) = ');
CHAIR=input('Chair areas (in m^2) = ');
FLOORAREA = L*W + h*N*W;
CEILINGAREA = L*W;
BOARDAREA = W*H;
BACKAREA = W*H - N*h;
INITIAL_VOLUME=L*W*H;
i=1;
if N>=1
while i>=1 && i<=N
    VANISHEDAREA = (h*i)*((L-S)/N);
    ONE_SIDEAREA = L*H - VANISHEDAREA; % ONE SIDE AREA
    i= i+1;
end
SIDEAREA_1 = ONE_SIDEAREA - Windows_side1;
i=1;
while i>=1 && i<=N
    VANISHEDAREA_OTHER = (h*i)*((L-S)/N);
    OTHER_SIDEAREA = L*H - VANISHEDAREA_OTHER; % OTHER ONE SIDE AREA
    i= i+1;
end
SIDEAREA_2 = OTHER_SIDEAREA - Windows_side2;
i=1;
while i>=1 && i<=N
    VANISHEDVOLUME = (h*i)*((L-S)/N)*W;
    VOLUME = INITIAL_VOLUME - VANISHEDVOLUME; % NET VOLUME
    i = i+1;
end
else
    SIDEAREA_1 = L*H - Windows_side1;
    SIDEAREA_2 = L*H - Windows_side2;
    VOLUME = INITIAL_VOLUME;
end
%% NUMBER OF OPTIMAL PERSON

% 1 = CLASSICAL CONCERT HALL
% 2 = HALION OPERA
% 3 = MOVIE THEATER
% 4 = CONFERENCE HALLS
InputFile=(uigetfile('*.txt', 'Select Data file'));
M=dlmread(InputFile);
p = input('Type of the Room (in numbers) = ');
PEOPLE = floor(VOLUME/M(p,1));
%% REVERBERATION TIME

% for u values
% 1 = 125 Hz
% 2 = 500 Hz
% 3 = 2000 Hz
% 4 = 4000 Hz
u = input('Determine the frequency for the absorbation rate of materials = ');
% ABSORPTION RATE 

% 2 = Brick
% 3 = Carpet(Concrete Floor)
% 4 = Curtain(Flat Near a Wall)
% 5 = Curtain(Pleated)
% 6 = Windows
% 7 = Audience(Fully Furnished Chair) Per/Person
% 8 = Audience(on Wood or Canvas)
% 9 = Empty Chair(Fully Furnished)
% 10 = Empty Chair(Wood or Canvas)
% 11 = Absorbers
% 12 = Concrete
% 13 = Floor(COMSOL DATA)
InputFile=(uigetfile('*.txt', 'Select Data file'));
K=dlmread(InputFile);
F = input('Floor absorption material = ');
A_Floor = FLOORAREA*K(u,F);
C =input('Ceiling absorption material = ');
A_Ceiling = CEILINGAREA*K(u,C);
BOARD = input('BOARDAREA absorption material = ');
A_Board = BOARDAREA*K(u,BOARD);
BACK = input('BACKAREA absorption material = ');
A_Back =BACKAREA*K(u,BACK);
S1 = input('Side_1 absorption material = ');
A_S1 = SIDEAREA_1*K(u,S1);
S2 = input('Side_2 absorption material = ');
A_S2 = SIDEAREA_2*K(u,S2);
A_Windows = (Windows_side1 + Windows_side2)*K(u,6);
PEOPLE_ABSORPTION = input('Audience absorption rate = ');
A_People = PEOPLE*K(u,PEOPLE_ABSORPTION);
CHAIR_ABSORPTION = input('Chair absorption rate = ');
A_Chair = CHAIR*K(u,CHAIR_ABSORPTION);
%% SABINE FORMULA
T_PEOPLE = (0.16*VOLUME)/(A_Floor+A_Board+A_Ceiling+A_S1+A_S2+A_Windows+A_People)
T_EMPTY = (0.16*VOLUME)/(A_Floor+A_Board+A_Ceiling+A_S1+A_S2+A_Windows+A_Chair)
%% IDEAL REVERBERATION TIME

% r = 4 for speech
% r = 5 for orchestra
% r = 6 for choros
AREA_AUDIENCE=A_Floor+A_Board+A_Ceiling+A_S1+A_S2+A_Windows+A_People;
AREA_EMPTY=A_Floor+A_Board+A_Ceiling+A_S1+A_S2+A_Windows+A_Chair;
r = input ('the value of "r" = ');
t = r*(0.012*(VOLUME^(1/3))+0.1070) ;
absorption_material=0.5;
alfa_people = (0.16*VOLUME)/(AREA_AUDIENCE*(absorption_material-(K(u,S1)/3)-(K(u,S2)/3)-(K(u,BOARD)/3)))
alfa_empty = (0.16*VOLUME)/(AREA_EMPTY*(absorption_material-(K(u,S1)/3)-(K(u,S2)/3)-(K(u,BOARD)/3)))