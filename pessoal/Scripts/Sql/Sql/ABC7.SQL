DELETE SYS.PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO SYS.PLAN_TABLE FOR
select ex.exception_id
from so_headers_all h , 
     so_order_types_all ot , 
     so_exceptions ex , 
     so_picking_batches_all p
WHERE (ex.request_id = p.request_id 
       and ex.id_number = h.header_id 
       and h.order_type_id = ot.order_type_id
       and ex.context = 'OEMSG_CNTXT_ORD_HEADER'
       and p.batch_id = to_number('1537'))
  AND (:request_id = ex.request_id)
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id
from so_headers_all h ,
     so_order_types_all ot ,
     so_lines_all l ,
     so_exceptions ex , 
     so_picking_batches_all p
WHERE (h.header_id = l.header_id 
       and ex.request_id = p.request_id 
       and h.order_type_id = ot.order_type_id 
       and ex.id_number = l.line_id 
       and ex.context = 'OEMSG_CNTXT_ORD_LINE'
       and p.batch_id = to_number('1537')) 
  AND (:request_id = ex.request_id) 
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id 
from so_headers_all h ,
     so_order_types_all ot ,
     so_lines_all l , 
     so_line_details ld ,
     so_exceptions ex , 
     so_picking_batches_all p
WHERE (h.header_id = l.header_id 
       and l.line_id = ld.line_id 
       and ex.request_id = p.request_id 
       and h.order_type_id = ot.order_type_id 
       and ex.id_number = ld.line_detail_id 
       and ex.context = 'OEMSG_CNTXT_ORD_DETAIL'
       and p.batch_id = to_number('1537')) 
  AND (:request_id = ex.request_id)
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id 
from so_picking_headers_all ph , 
     so_headers_all h , 
     so_order_types_all ot , 
     so_exceptions ex  
WHERE (h.header_id = ph.order_header_id (+) 
       and ex.id_number = h.header_id 
       and h.order_type_id = ot.order_type_id 
       and ex.context = 'OEMSG_CNTXT_ORD_HEADER'
       and ph.batch_id = to_number('1537')) 
  AND (:request_id = ex.request_id)
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id 
from so_headers_all h , 
     so_order_types_all ot ,
     so_lines_all l , 
     so_picking_headers_all ph ,
     so_exceptions ex
WHERE (h.header_id = l.header_id 
       and h.header_id = ph.order_header_id (+) 
       and h.order_type_id = ot.order_type_id 
       and ex.id_number = l.line_id 
       and ex.context = 'OEMSG_CNTXT_ORD_LINE'
       and ph.batch_id = to_number('1537')) 
  AND (:request_id = ex.request_id) 
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id 
from so_headers_all h , 
     so_order_types_all ot ,
     so_lines_all l , 
     so_line_details ld , 
     so_picking_headers_all ph , 
     so_exceptions ex
WHERE (h.header_id = l.header_id 
       and l.line_id = ld.line_id 
       and h.header_id = ph.order_header_id (+) 
       and h.order_type_id = ot.order_type_id 
       and ex.id_number = ld.line_detail_id 
       and ex.context = 'OEMSG_CNTXT_ORD_DETAIL'
       and ph.batch_id = to_number('1537')) 
  AND (:request_id = ex.request_id)
  AND (:program_id1 = ex.program_id)
UNION select ex.exception_id 
from so_exceptions ex , 
     so_order_types ot ,
     so_sales_credits sc , 
     so_headers h
WHERE (sc.header_id = h.header_id 
       and ex.id_number = sc.header_id 
       and h.order_type_id = ot.order_type_id 
       and ex.context = 'OEPUR: SO_SALES_CREDITS') 
  AND (:request_id = ex.request_id)
  AND (:program_id1 = ex.program_id)
ORDER BY 3 ASC,7 ASC,8 ASC,2 ASC
/
col options for a15
col operation for a50
col linhas for a15
select lpad('.',2*(level-1))||operation operation,
       options,
       object_name
--       DECODE(id,0,'Custo = '||position,cardinality) Linhas
from sys.plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior id = parent_id and statement_id = 'ABC4'
/
