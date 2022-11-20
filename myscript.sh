#! /bin/bash

 rm *.meow

#вывод имени студента с наилучшей посещаемостью и количество посещенных им занятий;
function punkt1 {

    if [ $# -lt 1 ]
    then
    echo -e "Нет входных параметров для работы программы! Запустите программу заново."
    exit
    fi

    group=$1
    proverka=students/groups/$group

    while [ ! -f "$proverka" ]
    do 
    echo "Группа указана неверно."
    read -p "Введите правильный номер группы: " group
    proverka=students/groups/$group
    done

    put=$group
    put+="-attendance"


    while IFS=' ' read -r name attendance
    do

        if [ "$name" != "$test_name" ]
        then 
         count=0
            for ((i=1; i <= ${#attendance} ; i++))
             do
                 if [ ${attendance:i-1:1} -eq 1 ]
                 then
                     ((count++))
                 fi    
            done

        fi

        if [ "$name" = "$test_name" ]
        then 

            for ((i=1; i <= ${#attendance} ; i++))
            do
                 if [ ${attendance:i-1:1} -eq 1 ]
                 then
                     ((count++))
                 fi    
            done
            echo $count $name >> mur1.meow
        fi

    test_name=${name}   
    done <<< "$(cat ./*/$put | sort -n)"

    sort -r mur1.meow > mur2.meow
    read -r max_lessons name_max <<< "$(head -n 1 mur2.meow)"
    echo -e "\nИнформация о студентах с максимальной посещаемостью:"
    i=1
    while IFS=' ' read -r lessons name 
    do 
        if [ $lessons -eq $max_lessons ]
        then
          echo -e "$i. Имя: $name; Количество занятий: $lessons"
          ((i++))
        fi      
    done < mur2.meow
    rm *.meow

}



#вывод имени студента с наихудшей посещаемостью и количество посещенных им занятий;
function punkt2 {

    if [ $# -lt 1 ]
    then
        echo -e "Нет входных параметров для работы программы! Запустите программу заново."
        exit
    fi

    group=$1
    proverka=students/groups/$group

    while [ ! -f "$proverka" ]
    do 
        echo "Группа указана неверно."
        read -p "Введите правильный номер группы: " group
        proverka=students/groups/$group
    done

    put=$group
    put+="-attendance"
    test_name=test

    while IFS=' ' read -r name attendance
    do
    
        if [ "$name" != "$test_name" ]
        then 
            count=0
            for ((i=1; i <= ${#attendance} ; i++))
            do
                if [ ${attendance:i-1:1} -eq 1 ]
                then
                    ((count++))
                fi    
            done
        

        fi

        if [ "$name" = "$test_name" ]
        then 

            for ((i=1; i <= ${#attendance} ; i++))
            do
                if [ ${attendance:i-1:1} -eq 1 ]
                then
                    ((count++))
                fi    
            done
            echo $count $name >> mur1.meow
        fi

        test_name=${name}

    done <<< "$(cat ./*/$put | sort -n)"

    sort -n mur1.meow > mur2.meow

    read -r min_lessons name_min <<< "$(head -n 1 mur2.meow)"
    echo -e "\nИнформация о студентах с минимальной посещаемостью:"
    i=1
    while IFS=' ' read -r lessons name 
    
    do 
        if [ "$lessons" = "$min_lessons" ]
        then
            echo -e "$i. Имя: $name; Количество занятий: $lessons"
            ((i++))
        fi      
    done < mur2.meow
    rm *.meow
}


#вывод имени студента, не сдавшего хотя бы один тест (с указанием номера теста);
function punkt3 {

    if [ $# -lt 1 ]
    then
        echo -e "Нет входных параметров для работы программы! Запустите программу заново."
        exit
    fi

    group=$1
    proverka=students/groups/$group
    
    while [ ! -f "$proverka" ]
    do 
        echo "Группа указана неверно."
        read -p "Введите правильный номер группы: " group
        proverka=students/groups/$group
    done

    fl=0
    for var in TEST-1 TEST-2 TEST-3 TEST-4
    do
        echo "//" > mur1.meow
        cat ./Пивоварение/tests/$var | egrep "^$group" >> mur1.meow
        awk '{FS=";"} {print $1,$2,$5}' mur1.meow > mur2.meow
        sort -r mur2.meow > mur3.meow
        i=1
        test_name=test
        while IFS=' ' read -r group_num name evaluation
        do 
                if [ "$name" != "$test_name" ]
                then
                    if [ "$evaluation" = "2" ]
                    then
                         echo -e "Имя: $name из группы $group; Все попытки сдать тест $var по Пивоварению провалены:("
                         ((i++))
                         ((fl++))
                     fi   
                     test_name=${name}
                fi
        done < mur3.meow
    done

    rm *.meow


    for var in TEST-1 TEST-2 TEST-3 TEST-4
    do
        echo "//" > mur1.meow
        cat ./Криптозоология/tests/$var | egrep "^$group" >> mur1.meow
        awk '{FS=";"} {print $2,$5}' mur1.meow > mur2.meow
        sort -r mur2.meow > mur3.meow
        i=1
        test_name=test
        while IFS=' ' read -r name evaluation
        do 
            if [ "$name" != "$test_name" ]
            then
                if [ "$evaluation" = "2" ]
                then
                    echo -e "Имя: $name; Все попытки сдать тест $var по Криптозоологии провалены:("
                    ((i++))
                    ((fl++))
                fi   
                test_name=${name}
            fi
        done < mur3.meow
    done
 
        if [ "$fl" = "0" ]
        then 
            echo " Нет таких людей"
        fi



    rm *.meow
}


rm .meow
#вывод списка студентов, сдавших все тесты с первой попытки;
function punkt4 {
  
    fl=0
    i=0
    fio_list=$(cat students/groups/*)

    while IFS=' ' read -r name
    do 

       echo "" > stud.meow
        egrep -h -m 1 ".*$name.*" ./*/tests/* >> stud.meow
        
        awk '{FS=";"} {print $5}' stud.meow > stud1.meow

        awk 'NF > 0' stud1.meow > mur4.meow

        least=$(sort -n mur4.meow | head -n 1)

        if [ "$least" != "2" ]
        then 
            echo "Имя: $name; Молодец, сдал с первой поптыки все тесты!"
            ((fl++))
        fi
  
    done <<< "$fio_list"


    if [ "$fl" = "0" ]
    then 
        echo " Нет таких людей"
    fi


    rm *.meow
}



#вывод по фамилии студента его средней оценки по всем тестам;
function punkt5 {

    if [ $# -lt 1 ]
    then
        echo -e "Нет входных параметров для работы программы! Запустите программу заново."
        exit
    fi

    list_sur=$(cat ./*/groups/*)
    fl=2
    fio=$1
    while [ "$fl" = "2" ]
    do

        for student in $list_sur
        do
            if [ "$student" = "$fio" ]
            then
                fl=1
            fi
        done
        if [ "$fl" = "2" ] 
        then
            echo "Фамилия студента указана неверно."
            read -p "Введите фамилию студента: " fio
        fi
    done


    summ=0
    count=0
    echo "//" > att5.tmp
    cat ./*/tests/* | grep $fio >> att5.tmp
    awk '{FS=";"} {print $2,$5}' att5.tmp > att6.tmp

    while IFS=' ' read -r name evaluation
    do

        if [ "$name" != "" ] 
        then 
            ((summ+=evaluation))
            ((count++))
        fi
    done < att6.tmp


    sr_summ=`echo "$summ/$count" | bc -l`
    echo -e " Студент: $fio; Средний балл по всем предметам: $sr_summ"

    rm *.tmp
}



#вывод по фамилии студента его досье; возможность добавления новых фраз в досье.
function punkt6 {

    if [ $# -lt 1 ]
    then
        echo -e "Нет входных параметров для работы программы! Запустите программу заново."
        exit
    fi

    list_sur=$(cat ./*/groups/*)
    fl=2
    fio=$1
    while [ "$fl" = "2" ]
    do

        for student in $list_sur
        do
            if [ "$student" = "$fio" ]
            then
                fl=1
            fi
        done
        if [ "$fl" = "2" ] 
        then
            echo "Фамилия студента указана неверно."
            read -p "Введите фамилию студента: " fio
        fi
    done


    IFS=":" read -r put number female <<< "$(egrep -n $fio ./students/general/notes/*.log)"

    ((number++))
    str="$(sed -n "$number p" $put)"
    echo -e "Досье студента:\n $str"

    new_str=$str

    echo "Введите дополнение: "
    read dop
    new_str+="$dop"

    echo -e "Новое досье студента:\n $new_str"

    sed -i -n "s/$str/$new_str/g" $put
    rm ./students/general/notes/*.log-n
}








#Создаем меню
function menu {
clear
echo
echo -e "\t\t\tМЕНЮ\n"
echo -e "\t1. Вывод имени студента с наихудшей посещаемостью и количество посещенных им занятий;"
echo -e "\t2. Вывод имени студента с наилучшей посещаемостью и количество посещенных им занятий;"
echo -e "\t3. Вывод имени студента, не сдавшего хотя бы один тест (с указанием номера теста);"
echo -e "\t4. Вывод списка студентов, сдавших все тесты с первой попытки;"
echo -e "\t5. Вывод по фамилии и инициалам студента его средней оценки по всем тестам;"
echo -e "\t6. Вывод по фамилии и инициалам студента его досье; возможность добавления новых фраз в досье;"
echo -e "\t0. Выход"
echo -en "\t\tВведите номер пункта: "
read -n 1 option
echo -e "\n "
}
#Используем цикл While и команду Case для создания меню.
while [ $? -ne 1 ]
do
        menu
        case $option in
0)
        break ;;
1) 
         read -p "Введите номер группы студента: " number
         punkt1 $number
         ;;
2)
         read -p "Введите номер группы студента: " number
         punkt2 $number
         ;;
3)
         read -p "Введите номер группы студента: " number
         punkt3 $number
        #Nazvanie
        ;;
4)
        punkt4
         ;;
5)
         read -p "Введите фамилию и инициалы  студента: " fio
         punkt5 $fio
         ;;
6)
        read -p "Введите фамилию и инициалы студента: " fio
        punkt6 $fio
        ;;
*)
        clear
echo "Некорректо введено значение";;
esac
echo -en "\n\n\t\t\tНажмите любую клавишу для продолжения"
read -n 1 line
done
clear


