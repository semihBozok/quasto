set serveroutput on;

prompt uninstall all objects
declare
  type t_vc2_array is table of varchar2(1000) index by varchar2(100);

  l_object_name t_vc2_array;
  l_object_type t_vc2_array;
  l_object      varchar2(100 char);
  l_key         varchar2(100 char);
  l_action      varchar2(32767);
  l_count       number;
begin
  -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);
  -- objects:
  -- tables
  l_object_name('UTPLSQL_CALENDAR') := 'UTPLSQL_CALENDAR';
  l_object_type('UTPLSQL_CALENDAR') := 'TABLE';
  l_object_name('UTPLSQL_TEST_CASE') := 'UTPLSQL_TEST_CASE';
  l_object_type('UTPLSQL_TEST_CASE') := 'TABLE';
  l_object_name('UTPLSQL_TEST_SUITE') := 'UTPLSQL_TEST_SUITE';
  l_object_type('UTPLSQL_TEST_SUITE') := 'TABLE';
  l_object_name('UTPLSQL_TEST_RUN') := 'UTPLSQL_TEST_RUN';
  l_object_type('UTPLSQL_TEST_RUN') := 'TABLE';
  l_object_name('QA_RULES') := 'QA_RULES';
  l_object_type('QA_RULES') := 'TABLE';

  -- packages
  l_object_name('PREPARE_TEST_RESULTS_PKG') := 'PREPARE_TEST_RESULTS_PKG';
  l_object_type('PREPARE_TEST_RESULTS_PKG') := 'PACKAGE';
  l_object_name('CREATE_UT_TEST_PACKAGES_PKG') := 'CREATE_UT_TEST_PACKAGES_PKG';
  l_object_type('CREATE_UT_TEST_PACKAGES_PKG') := 'PACKAGE';
  l_object_name('EXPORT_IMPORT_RULES_PKG') := 'EXPORT_IMPORT_RULES_PKG';
  l_object_type('EXPORT_IMPORT_RULES_PKG') := 'PACKAGE';
  l_object_name('QA_EXPORT_IMPORT_RULES_PKG') := 'QA_EXPORT_IMPORT_RULES_PKG';
  l_object_type('QA_EXPORT_IMPORT_RULES_PKG') := 'PACKAGE';
  l_object_name('QA_MAIN_PKG') := 'QA_MAIN_PKG';
  l_object_type('QA_MAIN_PKG') := 'PACKAGE';
  l_object_name('QA_API_PKG') := 'QA_API_PKG';
  l_object_type('QA_API_PKG') := 'PACKAGE';
  l_object_name('QA_APEX_PKG') := 'QA_APEX_PKG';
  l_object_type('QA_APEX_PKG') := 'PACKAGE';

  -- types
  l_object_name('VARCHAR2_TAB_T') := 'VARCHAR2_TAB_T';
  l_object_type('VARCHAR2_TAB_T') := 'TYPE';
  l_object_name('QA_RULES_T') := 'QA_RULES_T';
  l_object_type('QA_RULES_T') := 'TYPE';
  l_object_name('QA_RULE_T') := 'QA_RULE_T';
  l_object_type('QA_RULE_T') := 'TYPE';  

  -- sequences
  l_object_name('CLDR_SEQ') := 'CLDR_SEQ';
  l_object_type('CLDR_SEQ') := 'SEQUENCE';
  l_object_name('CASE_SEQ') := 'CASE_SEQ';
  l_object_type('CASE_SEQ') := 'SEQUENCE';
  l_object_name('RUN_SEQ') := 'RUN_SEQ';
  l_object_type('RUN_SEQ') := 'SEQUENCE';
  l_object_name('QARU_SEQ') := 'QARU_SEQ';
  l_object_type('QARU_SEQ') := 'SEQUENCE';
  l_object_name('SUITE_SEQ') := 'SUITE_SEQ';
  l_object_type('SUITE_SEQ') := 'SEQUENCE';
  
  -- synonyms
  l_object_name('QA_RULE_T_S') := 'QA_RULE_T';
  l_object_type('QA_RULE_T_S') := 'SYNONYM';

  l_object := l_object_name.first;
  dbms_output.put_line(l_object);
  dbms_output.put_line(l_object_type(l_object));
  dbms_output.put_line(l_object_name.next(l_object));
  dbms_output.put_line(l_object_name.last);


  while l_object is not null
  loop
    if l_object is null
    then
      return;
    end if;
    if l_object_type(l_object) = 'TABLE'
    then
      dbms_output.put_line(l_object);
      for i in (select constraint_name
                from user_constraints
                where table_name = l_object_name(l_object)
                and constraint_type = 'R')
      loop
        l_action := 'alter table ' || l_object_name(l_object) || ' drop constraint ' || i.constraint_name;
		
        select count(1)
        into l_count
        from user_constraints s
        where constraint_name = i.constraint_name;
		
        if l_count <> 0
        then
          dbms_output.put_line(l_action);
          execute immediate (l_action);
          dbms_output.put_line('INFO: ' || i.constraint_name || ' dropped.');
        else
          dbms_output.put_line('WARNING: ' || i.constraint_name || ' does not exist.');
        end if;
		
        select count(1)
        into l_count
        from user_constraints s
        where constraint_name = i.constraint_name;
		
        if l_count <> 0
        then
          dbms_output.put_line('WARNING: ' || i.constraint_name || ' has not been dropped correctly.');
        end if;
      
      end loop;
    end if;
    l_object := l_object_name.next(l_object);
  end loop;

  l_object := l_object_name.first;
  while l_object is not null
  loop
    l_action := 'drop ' || l_object_type(l_object) || ' ' || l_object_name(l_object);
	
    select count(1)
    into l_count
    from user_objects s
    where object_name = l_object_name(l_object)
    and object_type = l_object_type(l_object);
	
    if l_count <> 0
    then
      execute immediate (l_action);
      dbms_output.put_line('INFO: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' dropped.');
    else
      dbms_output.put_line('WARNING: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' does not exist.');
    end if;
	
    select count(1)
    into l_count
    from user_objects s
    where object_name = l_object_name(l_object)
    and object_type = l_object_type(l_object);
	
    if l_count <> 0
    then
      dbms_output.put_line('WARNING: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' has not been dropped correctly.');
    end if;
    l_object := l_object_name.next(l_object);
  end loop;


exception
  when others then
    dbms_output.put_line('ERROR: ' || l_action || ' drop failed!' || substr(sqlerrm
                                                                           ,0
                                                                           ,200));
end;
/

-- Empty recyclebin because of lobs in user_objects after dropping objects with lobs
purge recyclebin;