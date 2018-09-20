
% 多模块贝叶斯网络模型的搭建和求解
clear
clc
n=3;
ns=[5 4 5];%节点属性值的个数
 A=1;B=2;C=3;
Class=3;
%节点的次序
order=[1 2 3];
max_fan_in=1;%定义最大父节点数目
result_matrix=zeros(ns(Class),ns(Class));
%读入数据
data_train=load('data_pd.csv');
[num_attrib,num_cases]=size(data_train');
data_train0=zeros(num_attrib,num_cases);
%建立贝叶斯网络
dag_gbn=zeros(n,n);
dag_gbn=learn_struct_K2(data_train0,ns,order,'max_fan_in',1);
bnet2=mk_bnet(dag_gbn,ns);
draw_graph(dag_gbn);
priors=1;
%选择polytree
engine = belprop_polytree_discrete(bnet2);
%输入证据
evidence = cell(1,N);
% evidence{A} = 2;
[engine, loglike] = enter_evidence(engine, evidence);
seed=0;
rand('state',seed);
for i=1:n
bnet2.CPD{i}=tabular_CPD(bnet2,i,'propextent','kill_and_wound','region','crit1','crit2','crit3','success','suicide','attacktype1','targtype1','nperps','weaptype1','ransom',1);
end
bnet4=bayes_update_params(bnet2,data_train0);
CPT3=cell(1,n);
for i=1:n
s=struct(bnet4,CPD{i});
CPT3{i}=s.CPT;
end