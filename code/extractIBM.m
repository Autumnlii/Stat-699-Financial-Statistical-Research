clear
clf

% create return files, negative, positive, standardized
% IBM 1/4/1982 -12/31/2002 Data from WRDS 
% 06/04/2003

day=[31 28 31 30 31 30 31 31 30 31 30 31];
day1=[31 29 31 30 31 30 31 31 30 31 30 31];
%months='JanFebMarAprMayJunJulAugSepOctNovDec';

n=5311;

for j=1:1,
    nd=7670;    % day 01/04/82 = 1,    12/31/02 = 7670
    filedate=['IBM.date'];
    fileclose=['IBM.close'];
    closeprice=load(fileclose);
    fid=fopen(filedate,'r');
    for i=1:n(j),
        record=fgets(fid);
        I1=findstr('/',record);
        closing(i,j)=closeprice(i);
        year=str2num(record(I1(2)+1:I1(2)+4));
        month=str2num(record(1:I1(1)-1));
        daycount=str2num(record(I1(1)+1:I1(2)-1));
        yy=floor(year/4)*4;
        if yy==year
            days=day1(month);
            ct(i,j)=(year-1982)*365+sum(day1(1:month-1))+floor((year-1981)/4)+daycount;  
        else
            days=day(month);
            ct(i,j)=(year-1982)*365+sum(day(1:month-1))+floor((year-1981)/4)+daycount;
        end;
        if ct(i,j)>=nd     % check repeated days
            [j ct(i,j)]
            [month daycount year]
        end
        %nd=ct(i,j);
    end
    ST=fclose(fid);
    for i=1:n(j)-1,
        re(i,j)=log(closing(i+1,j)/closing(i,j));   % negative log return
    end
end
%save IBM.return re -ASCII
%stop

figure(2)
vt=load('IBM11.sigma.t.sdd');
plot(vt)
title('Estimated Conditional Standard Deviation Using GARCH(1,1)')
xlabel('IBM data')

nn(1)=length(vt);
vlt0=vt; 

print -deps IBMvt11.eps


[nnn m]=size(ct);
nmax=max(max(ct));
for j=1:m,
    for i=1:n(j)-1,
        if ct(i,j)>0
            ret(ct(i,j),j)=re(i,j);    % re-arrange the data according actually date
        end
    end
end
[nnn m]=size(ret);

I=find(ret(:,1));
i1=I(1);
ret=ret(i1:nnn,:);

for j=1:m,
    for i=1:nn(j),
        if ct(i,j)>0
            vlt1(ct(i,j),j)=vlt0(i,j);
        end
    end
end
[nnn m]=size(vlt1);
vlt1=vlt1(i1:nnn,:);

figure(1)
for i=1:1,
    I=find(ret(:,i));
    hold on
    axis([0 7800 -0.20 0.20]);
    timeplot(I, -ret(I,i))               % negative return
    dateaxis('X',2,'01/04/82')
    xlabel('IBM')
    ylabel('Neg Log Return')
    if i==1
        title('Negative Daily Return 1982-2002')
    else
        title('                               ')
    end
    hold off
end
orient('tall')
print -deps IBMori.eps

figure(3)
for i=1:1,
    I=find(ret(:,i));
    hold on
    axis([0 7800 -10.0 10]);
    timeplot(I, -ret(I,i)./vlt1(I,i))               % negative return
    dateaxis('X',2,'01/04/82')
    xlabel('IBM')
    ylabel('Neg Log Return')
    if i==1
        title('Negative Daily Return Divided by Estimated Standard Deviation, 1982-2002 ')
    else
        title('                               ')
    end
    hold off
end
orient('tall')
print -deps IBMdvt11.eps    % IBM/vt11


I=find(ret(:,1)<0);
SP=[I -ret(I,1)];
save IBM.neg SP -ASCII            % actually date of drop

k=1;
[n m]=size(ret);
for i=1:n,
    p=0;
    for j=1:m,
        if vlt1(i,j)>0
            p=1;
        end
    end
    if p==1
        retu(k,:)=ret(i,:);
        for j=1:m,
            if vlt1(i,j)>0
                sretu(k,j)=ret(i,j)/vlt1(i,j);     % standardized return
            end
        end
        k=k+1;
    end
end

rr=-retu(:,1);
save IBMneg.txt rr -ASCII              % neg return  

rr=-sretu(:,1);
save IBMsneg.txt rr -ASCII             % standardized neg return

I=find(retu(:,1)<0);
SP=[I -retu(I,1)];
SPs=[I -sretu(I,1)];
save IBMdrop.txt SP -ASCII            %  drop 
save IBMsdrop.txt SPs -ASCII          %  standardized series
I=find(abs(retu(:,1))>0);
absrr=[I abs(retu(I,1))];
save IBMabs.txt absrr -ASCII
absrr=[I abs(sretu(I,1))];
save IBMsabs.txt absrr -ASCII

% save positive returns to a file

I=find(retu(:,1)>0);
SP=[I retu(I,1)];
SPs=[I sretu(I,1)];
save IBMpos.txt SP -ASCII            %  positive returns 
save IBMspos.txt SPs -ASCII          %  standardized series


