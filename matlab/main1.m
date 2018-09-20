
% 财产损失模块的贝叶斯网络的搭建及其条件概率矩阵的求解
clear
clc
%建立贝叶斯网络结构并制定条件概率表
N = 12;  %网络的节点数
dag = zeros(N,N);% 节点之间的连接关系
A = 1; B = 2;C = 3; D = 4; E = 5; F = 6; G = 7; H = 8; I = 9; J = 10; K = 11; L = 12; 
% dag(A,[F G]) = 1; % 两个节点之间有连接，即为1
dag(B,[E J K L]) = 1;
dag(C,D) = 1;
dag(D,E) = 1;
dag(F,A) = 1;
dag(G,A) = 1;
dag(H,[C F G]) = 1;
dag(K,[H I]) = 1;
dag(L,E) = 1;
discrete_nodes = 1:N; % 离散节点
node_sizes = [4 12 2 2 2 2 2 9 22 5 13 3];% 节点状态数
% bnet =mk_bnet(dag,node_sizes,'diserete',discrete_nodes);
bnet =mk_bnet(dag,node_sizes,'names',{'propextent','region','crit1','crit2','crit3','success','suicide','attacktype1','targtype1','nperps','weaptype1','ransom'},'discrete',discrete_nodes);  % 生成贝叶斯网络  
CPT = reshape([1 0.1 0.1 0.01 0 0.9 0.9 0.99], [2 2 2]); %
%  bnet.CPD{A} = tabular_CPD(bnet,A,[0.2 0.1 0.1 0.1 0.8 0.2 0.6 0.1 0 0.3 0.2 0.3 0 0.4 0.1 0.5]);
% bnet.CPD{B} = tabular_CPD(bnet,B,[0.8 0.2 0.2 0.8]);
% bnet.CPD{C} = tabular_CPD(bnet,C,[0.5 0.9 0.5 0.1]);
% bnet.CPD{D} = tabular_CPD(bnet,D,[1 0.1 0.1 0.01 0 0.9 0.9 0.99]);
% bnet.CPD{E} = tabular_CPD(bnet,E,[0.9 0.1]);
% bnet.CPD{F} = tabular_CPD(bnet,F,[0.9 0.1]);
% bnet.CPD{G} = tabular_CPD(bnet,G,[0.9 0.1]);
% bnet.CPD{H} = tabular_CPD(bnet,H,[0.9 0.1]);
% bnet.CPD{I} = tabular_CPD(bnet,I,[0.9 0.1]);
% bnet.CPD{J} = tabular_CPD(bnet,J,[0.9 0.1]);
% bnet.CPD{K} = tabular_CPD(bnet,K,[0.9 0.1]);
% bnet.CPD{L} = tabular_CPD(bnet,L,[0.9 0.1]);
%画出建立好的贝叶斯网络
figure
draw_graph(dag)
fata_train1 = csvread('data_pd.csv');
[num_attrib num_cases]=size(data_train1);
data_train=zeros(num_attrib,num_cases);
%根据实例进行网络结构学习
dag_gbn=zeros(n,n);
dag_gbn=learn_struct-K2(data_train, ns, order, 'max_fan_in', max_fan_in);
bnet2=mk_bnet(dag_gbn,ns);
%选择联合树推理引擎
engine = jtree_inf_engine(bnet);
%对生成的结构进行参数学习
priors=1;
seed=0;
rand('state', seed);
for i=1:n
bnet2.CPD{i}=tabular_CPD(bnet2, i, 'propextent','region','crit1','crit2','crit3','success','suicide','attacktype1','targtype1','nperps','weaptype1','ransom', priors);
end
bnet4=bayes_update_params(bnet2, data_train);
CPT3 = cell(1,n);
for i=1:n
s=struct(bnet4,CPD{i});
CPT3{i}=s.CPT;
end

%输入证据
evidence = cell(1,N);
% evidence{A} = 2;
[engine, loglike] = enter_evidence(engine, evidence);
%计算单个节点后验概率，即进行推理
marg1 = marginal_nodes(engine,A);
marg1.T()
%计算对节点联合后验概率
marg2 = marginal_nodes(engine,[F G A]);
marg2.T

