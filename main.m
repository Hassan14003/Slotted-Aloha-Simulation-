clear all

%% Practically Generated Results
% No of Nodes = 200
% TotalSimulationTime=5000;
% packetlength=1;
% packet Transmission probability  = 0.0057
% maximum backoff = 100
% Backofflim = 100;
TotalSimulationTime=5000;
packetlength=1;
packetTransProb=0.0057;
Backofflim = 100;
N = 0:5:200;
throughput = zeros(1,length(N));
trafficOffered = zeros(1,length(N));
CollisionProab = zeros(1,length(N));
for i = 1:length(N)
    [throughput(i),G(i),CollisionProab(i)] = S_aloha(N(i),TotalSimulationTime,packetlength,packetTransProb,Backofflim);
end
figure(1)
plot(N,throughput,'r','Linewidth',1);
xlabel('\bfNumber of Nodes')
ylabel('\bfTroughput')
title('Number of Nodes VS Troughput')
figure(2)
plot(N,G,'k:');
xlabel('\bfNumber of Nodes')
ylabel('\bfLoad Offered')
title('Number of Nodes VS Load Offered')
figure(3)
plot(N,CollisionProab,'m','Linewidth',1);
xlabel('\bfNumber of Nodes')
ylabel('\bfProbability of Collision')
title('Number of Nodes VS Probability of Collision')
figure(4)
subplot(1,2,1)
plot(G,throughput,'b','Linewidth',1);
xlabel('\bfLoad Offered')
ylabel('\bfthroughput')
title('Practical Result: Load Offered VS Throughput')
text(G(find(throughput==max(throughput))),max(throughput),'Max Throughput')
%% Ideal Results and comparisons
G = 0:0.01:5;
S = G.*exp(-G);
figure(4)
subplot(1,2,2)
plot(G,S,'b.:');

hold on;
title('Slotted Aloha V/S Pure Aloha Protocol');
xlabel('Load Offered');
ylabel('Throughput');
text(1,.38,'Max Throughput for Slotted Aloha')

S = G.*exp(-2*G);
plot(G,S,'r.');
text(.5,.2,'Max Throughput for Pure Aloha')
hold off;