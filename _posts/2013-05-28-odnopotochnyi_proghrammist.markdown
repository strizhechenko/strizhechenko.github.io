---
layout: post
title: "Однопоточный программист"
date: '2013-05-28 12:10:00'
tags:
- riepost
- bydlokod_
- tipy_proghrammistov
- khabrakhabr
---

Наткнулся вчера на хабре на статью:&nbsp;[http://habrahabr.ru/post/181095/](http://habrahabr.ru/post/181095/)

Заметил за собой такую же проблему. Хотя не факт что за мной, может и за продуктом которым занимаюсь :)

Может я конечно и тупенький, но добление в процедуру поддержки двух значений параметров ACT - cancel и status вызвало у меня множество попоболи, причём status уже был реализован, но не подходил для нужной платёжной системы.

<a name="more"></a>begin
    if (ACT = ''
        or ACT is null) then
        ACT = 'CHECK';
    if (NEED_CONTINUE = 1 and upper(ACT) <> 'PAY' and upper(ACT) <> 'CHECK' and upper(ACT) <> 'STATUS') then
    begin
    end
    if (NEED_CONTINUE = 1 and upper(ACT) = 'PAY' and PAY_ID_STR is not null) then
    begin
    end
    if (NEED_CONTINUE = 1 and upper(ACT) = 'PAY') then  
    begin                                                       
    end
    if ( NEED_CONTINUE = 1 and (upper(ACT) <> 'STATUS') and ( (FINANCE_USER is null) or (FINANCE_USER <> 1))) then
    begin
    end

    if (NEED_CONTINUE = 1 and upper(ACT) = 'STATUS') then 
    begin
    end

    if (NEED_CONTINUE = 1 and upper(ACT) = 'CHECK') then
    begin
    end
    if (NEED_CONTINUE = 1) then
    begin
        тут неявно до сюда доходит только PAY;
        создаём запись об операции;
    end
    логируем;
    suspend;
    exit;
end
в голове так и вертелось желание сделать процедуруPAY_SYSTEM_STRATEGY

в которой

if (upper(ACT) = 'CHECK')  pay_system_check();
if (upper(ACT) = 'PAY')  pay_system_pay();
if (upper(ACT) = 'STATUS')  pay_system_status();
if (upper(ACT) = 'CANCEL')  pay_system_cancel();
В прочем когда на это взглянул один более менее адекватный коллега, он сказал что писали сказочные наркоманы :)