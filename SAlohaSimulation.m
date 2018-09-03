function varargout = SAlohaSimulation(varargin)
% SALOHASIMULATION MATLAB code for SAlohaSimulation.fig
%      SALOHASIMULATION, by itself, creates a new SALOHASIMULATION or raises the existing
%      singleton*.
%
%      H = SALOHASIMULATION returns the handle to a new SALOHASIMULATION or the handle to
%      the existing singleton*.
%
%      SALOHASIMULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SALOHASIMULATION.M with the given input arguments.
%
%      SALOHASIMULATION('Property','Value',...) creates a new SALOHASIMULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAlohaSimulation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAlohaSimulation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAlohaSimulation

% Last Modified by GUIDE v2.5 19-Jun-2018 18:12:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAlohaSimulation_OpeningFcn, ...
                   'gui_OutputFcn',  @SAlohaSimulation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SAlohaSimulation is made visible.
function SAlohaSimulation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAlohaSimulation (see VARARGIN)

% Choose default command line output for SAlohaSimulation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SAlohaSimulation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAlohaSimulation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
TotalSimulationTime=5000;
packetlength=1;
packetTransProb=0.0057;
Backofflim = 100;
N = 100;
%% Variable Declaration
UnitSlotlength = packetlength; % In Slotted Aloha, Total Simulation time is divided in time slots each of equal lenght which is equal to the length of the packet
TotalNoOfSlots = TotalSimulationTime/packetlength;
TransStatus = zeros(1,N);% For transmission status: If 1 then ready for transmission and if 0 then not ready
BackoffStatus = zeros(1,N);% Backoff Status of each Node, If maxium Backoff Limit is reached then that packet is said to be destroyed
TransAttempts = 0; % Packet Transmission attempts
NoOfackdPackets = 0; % Total Number of Acknowledged Packets
TotalNoOfCollision = 0;% Total Number of Collisions that occured
SlotPassed = 0;

%% Intializing Plotting
envSize=100;        %   envsizeXenvsize environment
xLocation = rand(N,1) * envSize;
yLocation = rand(N,1) * envSize;   %x,y coords of nodes

sinkNode = envSize*0.80;
handles.axes1;
xlabel('X-Location');
ylabel('Y-Location');
%plot(xLocation, yLocation, '*','Color','b','linewidth',1);
%filledCircle([sinkNode sinkNode],2,1000,'r');%
hold on;
for i = 1:length(xLocation)
       a = filledCircle([xLocation(i) yLocation(i)],0.8,1000,'b');% 
       %text(xLocation(i),xLocation(i),num2str(i),'Color','k','linewidth',5)
end
filledCircle([sinkNode sinkNode],2,1000,'r');% filled Circle is a downloaded file which actually plots a filled circle on graph
text(sinkNode, sinkNode, 'sink');
while SlotPassed <= TotalNoOfSlots
    SlotPassed = SlotPassed + 1;
    for i = 1:length(TransStatus)
        if TransStatus(1,i) == 0 && rand(1) <= packetTransProb % It checks for that if packed transmitted earlier or not, and its Back off limit has exceeded or not, and there is a probability to send the pakcet or not
            TransStatus(1,i) = 1;
            TransStatus(1,i) = randi(Backofflim,1);
        elseif TransStatus(1,i)==1 % backlogged packet
            BackoffStatus(1,i)=randi(Backofflim,1);
            
        end
    end

    TransAttempts = TransAttempts + sum(TransStatus == 1);

    if sum(TransStatus == 1) == 1
        NoOfackdPackets = NoOfackdPackets + 1;
        [~,sourceId] = find(TransStatus == 1);
        b = filledCircle([xLocation(sourceId) yLocation(sourceId)],0.8,1000,'g');% If node turns green then it means that Node's packet have been acknowledged
        %a = b;
    elseif sum(TransStatus == 1) > 1
        TotalNoOfCollision = TotalNoOfCollision + 1;
        TransStatus  = TransStatus + BackoffStatus;
        [~,sourceId] = find(TransStatus == 1);
        for i = 1:length(sourceId)
                 b(i) = filledCircle([xLocation(sourceId(i)) yLocation(sourceId(i))],0.8,1000,'r');% If node turns green then it means that Node's packet have been collided
                 %XTicks(0,1000)
                 %a = b(i);
        end
    end
    pause(0.2);
    %delete(a);
    %a = [];
    TransStatus = TransStatus - 1; % decrease backoff interval
    TransStatus(TransStatus < 0) = 0; % idle sources stay idle (see permitted statuses above)
    BackoffStatus = zeros(1,N);

end
