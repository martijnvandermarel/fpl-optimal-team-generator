close all; clear all;
t = readtable('fpl_scraped_data.csv','Encoding','UTF-8');
N = height(t); % number of players
w = t.now_cost; % weight: player prices
v = t.ep_next; % value: metric for how many points a player will score

def = find(string(t.position)=='Defender');
fwd = find(string(t.position)=='Forward');
gkp = find(string(t.position)=='Goalkeeper');
mid = find(string(t.position)=='Midfielder');

ars = find(string(t.team_name)=='Arsenal');
avl = find(string(t.team_name)=='Aston Villa');
bha = find(string(t.team_name)=='Brighton');
bur = find(string(t.team_name)=='Burnley');
che = find(string(t.team_name)=='Chelsea');
cry = find(string(t.team_name)=='Crystal Palace');
eve = find(string(t.team_name)=='Everton');
ful = find(string(t.team_name)=='Fulham');
lee = find(string(t.team_name)=='Leeds');
lei = find(string(t.team_name)=='Leicester');
liv = find(string(t.team_name)=='Liverpool');
mci = find(string(t.team_name)=='Man City');
mun = find(string(t.team_name)=='Man Utd');
new = find(string(t.team_name)=='Newcastle');
shu = find(string(t.team_name)=='Sheffield Utd');
sou = find(string(t.team_name)=='Southampton');
tot = find(string(t.team_name)=='Spurs');
wba = find(string(t.team_name)=='West Brom');
whu = find(string(t.team_name)=='West Ham');
wol = find(string(t.team_name)=='Wolves');

cvx_begin
    cvx_solver gurobi % because this is a mixed-integer program
    variable x(N) binary; % all dreamteam members
    variable b(N) binary; % bench players
    variable c(N) binary; % captain

    p_sub = 0.1; % approx. how likely it is that a bench player gets subbed in
    maximize(x'*v-(1-p_sub)*b'*v+c'*v) % maximize expected total points
    subject to
        x'*w <= 100; % budget constraint
        x-b >= zeros(N,1); % all bench players have to be part of dreamteam
        x-c >= zeros(N,1); % captain has to be part of dreamteam
        
        sum(x(def)) == 5; % 5 defenders
        sum(x(fwd)) == 3; % 3 forwards
        sum(x(gkp)) == 2; % 2 goalkeepers
        sum(x(mid)) == 5; % 5 midfielders
        sum(b(gkp)) == 1; % 1 goalkeeper on the bench
        sum(b([def;fwd;mid])) == 3; % 3 outfield players on bench
        sum(b(def)) <= 2; % max 2 defenders on the bench
        sum(b(fwd)) <= 2; % max 2 forwards on the bench
        sum(b(mid)) <= 3; % max 3 forwards on the bench
        sum(c) == 1; % 1 captain
        sum(x(ars)) <= 3; % max 3 players for ars
        sum(x(avl)) <= 3; % max 3 players for avl
        sum(x(bha)) <= 3; % max 3 players for bha
        sum(x(bur)) <= 3; % max 3 players for bur
        sum(x(che)) <= 3; % max 3 players for che
        sum(x(cry)) <= 3; % max 3 players for cry
        sum(x(eve)) <= 3; % max 3 players for eve
        sum(x(ful)) <= 3; % max 3 players for ful
        sum(x(lee)) <= 3; % max 3 players for lee
        sum(x(lei)) <= 3; % max 3 players for lei
        sum(x(liv)) <= 3; % max 3 players for liv
        sum(x(mci)) <= 3; % max 3 players for mci
        sum(x(mun)) <= 3; % max 3 players for mun
        sum(x(new)) <= 3; % max 3 players for new
        sum(x(shu)) <= 3; % max 3 players for shu
        sum(x(sou)) <= 3; % max 3 players for sou
        sum(x(tot)) <= 3; % max 3 players for tot
        sum(x(wba)) <= 3; % max 3 players for wba
        sum(x(whu)) <= 3; % max 3 players for whu
        sum(x(wol)) <= 3; % max 3 players for wol
cvx_end

% Print team
disp('Starting XI: ');
for i = 1:N
    if x(i) == 1 && b(i) == 0
        if c(i) == 1
            disp([char(t.web_name(i)) ' (c)']);
        else
            disp(char(t.web_name(i)))
        end
    end
end
disp(' ');
disp('Bench: ');
for i = 1:N
    if b(i) == 1
        disp(char(t.web_name(i)))
    end
end
disp(' ');
disp('Total price: ');
disp(x'*w);