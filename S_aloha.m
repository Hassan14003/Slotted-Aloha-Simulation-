function [throughput,G,CollisionProab] = S_aloha(NoOfNodes,TotalSimulationTime,packetlength,packetTransProb,Backofflim)
%% Inputs
% NoOfNodes = Total Number of Nodes in the network
% TotalSimulationTime = Total Time of the simulation
% packetlength = Lenght of Each packet which will be fixed in all the
% simulation time
% packetTransProb = It defines the probability for a particular packet for
% transmission
% Backofflim = The Maximum Limit of the Backoff 

%% Outputs
% throughput = The Overall eficiency of the simulation


UnitSlotlength = packetlength; % In Slotted Aloha, Total Simulation time is divided in time slots each of equal lenght which is equal to the length of the packet
TotalNoOfSlots = TotalSimulationTime/packetlength;
TransStatus = zeros(1,NoOfNodes);% For transmission status: If 1 then ready for transmission and if 0 then not ready
BackoffStatus = zeros(1,NoOfNodes);% Backoff Status of each Node, If maxium Backoff Limit is reached then that packet is said to be destroyed
TransAttempts = 0; % Packet Transmission attempts
NoOfackdPackets = 0; % Total Number of Acknowledged Packets
TotalNoOfCollision = 0;% Total Number of Collisions that occured
SlotPassed = 0;
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
    elseif sum(TransStatus == 1) > 1
        TotalNoOfCollision = TotalNoOfCollision + 1;
        TransStatus  = TransStatus + BackoffStatus;
    end

    TransStatus = TransStatus - 1; % decrease backoff interval
    TransStatus(TransStatus < 0) = 0; % idle sources stay idle
    BackoffStatus = zeros(1,NoOfNodes);

end

G = TransAttempts / TotalSimulationTime;% Total Traffic Offered
throughput = NoOfackdPackets / TotalSimulationTime; % throughput = Total Number Of Acknowledged Packets/Total Time of Simulation
CollisionProab = TotalNoOfCollision / TotalSimulationTime;% Packet Collision Probability = Total Number Of Packets Collided/Total Time of Simulation
