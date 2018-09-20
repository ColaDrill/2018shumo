
% �Ʋ���ʧģ��ı�Ҷ˹����Ĵ�����������ʾ�������
clear
clc
%������Ҷ˹����ṹ���ƶ��������ʱ�
N = 12;  %����Ľڵ���
dag = zeros(N,N);% �ڵ�֮������ӹ�ϵ
A = 1; B = 2;C = 3; D = 4; E = 5; F = 6; G = 7; H = 8; I = 9; J = 10; K = 11; L = 12; 
% dag(A,[F G]) = 1; % �����ڵ�֮�������ӣ���Ϊ1
dag(B,[E J K L]) = 1;
dag(C,D) = 1;
dag(D,E) = 1;
dag(F,A) = 1;
dag(G,A) = 1;
dag(H,[C F G]) = 1;
dag(K,[H I]) = 1;
dag(L,E) = 1;
discrete_nodes = 1:N; % ��ɢ�ڵ�
node_sizes = [4 12 2 2 2 2 2 9 22 5 13 3];% �ڵ�״̬��
% bnet =mk_bnet(dag,node_sizes,'diserete',discrete_nodes);
bnet =mk_bnet(dag,node_sizes,'names',{'propextent','region','crit1','crit2','crit3','success','suicide','attacktype1','targtype1','nperps','weaptype1','ransom'},'discrete',discrete_nodes);  % ���ɱ�Ҷ˹����  
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
%���������õı�Ҷ˹����
figure
draw_graph(dag)
fata_train1 = csvread('data_pd.csv');
[num_attrib num_cases]=size(data_train1);
data_train=zeros(num_attrib,num_cases);
%����ʵ����������ṹѧϰ
dag_gbn=zeros(n,n);
dag_gbn=learn_struct-K2(data_train, ns, order, 'max_fan_in', max_fan_in);
bnet2=mk_bnet(dag_gbn,ns);
%ѡ����������������
engine = jtree_inf_engine(bnet);
%�����ɵĽṹ���в���ѧϰ
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

%����֤��
evidence = cell(1,N);
% evidence{A} = 2;
[engine, loglike] = enter_evidence(engine, evidence);
%���㵥���ڵ������ʣ�����������
marg1 = marginal_nodes(engine,A);
marg1.T()
%����Խڵ����Ϻ������
marg2 = marginal_nodes(engine,[F G A]);
marg2.T

