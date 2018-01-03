insert into SACS_A_GLOBAL_AGGREGATION
        select A.PROD_REF,
               A.DEALER_ID,
               A.TRANS_DATE,
               DECODE (
                  NB_SOLD,
                  NULL,
                  0,
                  NB_SOLD
               ),
               0,
               0,
               0,
               0,
               DECODE (
                  NB_USED,
                  NULL,
                  0,
                  NB_USED
               ),
               0,
               0,
               sysdate,
               'AGGREGATOR',
               sysdate,
               'AGGREGATOR'
          from (select PROD_REF,
                       DEALER_ID,
                       TRANS_DATE,
                       sum (
                          NB_SOLD
                       )
                             NB_SOLD
                  from (select PROD_REF,
                               DEALER_ID,
                               TRANS_DATE,
                               to_number (
                                  END_VOUCHER_ID
                               ) -
                               to_number (
                                  START_VOUCHER_ID
                               ) +
                               1
                                     NB_SOLD
                          from SACS_T_VOUCHER_TRANSACTIONS)
                 group by PROD_REF,
                          DEALER_ID,
                          TRANS_DATE) A,
               (select DEALER_ID,
                       TRANS_DATE,
                       PROD_REF,
                       count (
                          VOUCHER_ID
                       )
                             NB_USED
                  from (select V.VOUCHER_ID
                                     VOUCHER_ID,
                               T.DEALER_ID
                                     DEALER_ID,
                               T.TRANS_DATE
                                     TRANS_DATE,
                               T.PROD_REF
                                     PROD_REF
                          from SACS_V_VOUCHER_USAGE V,
                               SACS_T_VOUCHER_TRANSACTIONS T
                         where to_number (
                                  V.VOUCHER_ID
                               ) <=
                                  to_number (
                                     T.END_VOUCHER_ID
                                  )
                           and to_number (
                                  V.VOUCHER_ID
                               ) >=
                                  to_number (
                                     T.START_VOUCHER_ID
                                  ))
                 group by DEALER_ID,
                          TRANS_DATE,
                          PROD_REF) B
         where A.PROD_REF =
                  B.PROD_REF (+)
           and A.DEALER_ID =
                  B.DEALER_ID (+)
           and A.TRANS_DATE =
                  B.TRANS_DATE (+)