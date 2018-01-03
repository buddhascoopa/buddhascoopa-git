---------------------------------------------------------------------
select 'OIBIF_DETALHE_FATURA' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF\_DETALHE\_FATURA\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_DETALHE_FATURA') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_DETALHE_FATURA'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------
select 'OIBIF_FATURA' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF\_FATURA\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_FATURA') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_FATURA'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------
select 'OIBIF_INFO_NOTAFISCAL' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF\_INFO\_NOTAFISCAL\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_INFO_NOTAFISCAL') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_INFO_NOTAFISCAL'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------
select 'OIBIF_MULTICONTA' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF\_MULTICONTA\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_MULTICONTA') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_MULTICONTA'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------
select 'OIBIF_TOTAL_NOTAFISCAL' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF\_TOTAL\_NOTAFISCAL\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_TOTAL_NOTAFISCAL') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_TOTAL_NOTAFISCAL'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------
select 'OIBIF_TOTAL_SECAO' tabela,
       ( select sum(bytes)/1024/1024
           from dba_segments
          where owner='TELEMAR'
            and segment_name like 'OIBIF_TOTAL_SECAO\_00_' escape '\') alocado,
       ( select tablespace_name
           from dba_tables
          where owner='ATFADM'
            and table_name='OIBIF_TOTAL_SECAO') ts,
       ( select sum(fs.bytes)/1024/1024
           from dba_free_space fs, dba_tables tb
          where tb.owner='ATFADM'
            and tb.table_name='OIBIF_TOTAL_SECAO'
            and fs.tablespace_name=tb.tablespace_name) free
from dual;
---------------------------------------------------------------------

