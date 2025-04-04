*&---------------------------------------------------------------------*
*&  Include           Z_TEST_SUYARGULOV_CLASSES
*&---------------------------------------------------------------------*

CLASS lcl_app IMPLEMENTATION.

  METHOD start.
    get_data( ).
    show_grid( ).
  ENDMETHOD.

  METHOD get_data.
    BREAK-POINT. "Для пропуска запроса и ввода тестовых данных.
    SELECT a~bukrs, b~banfn, b~bnfpo, b~matnr,
           b~menge AS eb_menge, a~ebeln, c~ebelp, c~menge AS ek_menge,
           d~belnr, d~buzei, d~menge AS rs_menge, d~shkzg
      INTO CORRESPONDING FIELDS OF TABLE @gt_data
      FROM eban AS b
      INNER JOIN ekko AS a
        ON b~ebeln = a~ebeln
      INNER JOIN ekpo AS c
        ON b~ebelp = c~ebelp
      INNER JOIN rseg AS d
        ON d~ebelp = c~ebelp
      INNER JOIN rbkp AS e
*        ON a~ebeln = e~ebeln "В моей версии SAP в т. RBKP нету EBELN, заменено на BELNR.
        ON d~belnr = e~belnr
      WHERE a~bukrs IN @so_bukrs
        AND b~banfn IN @so_banfn
        AND a~ebeln IN @so_ebeln
        AND e~belnr IN @so_belnr
        AND e~stblg = ''.

    IF sy-subrc = 0.
      convert_data( ).
    ELSE.
      MESSAGE '������ �� �������' TYPE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD convert_data.
    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      IF <fs_data>-shkzg = 'H'.
        <fs_data>-rs_menge = <fs_data>-rs_menge * -1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD show_grid.
    DATA: lo_events TYPE REF TO cl_salv_events_table.
    TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_grid
        CHANGING  t_table = gt_data
      ).

      go_grid->get_columns( )->set_optimize( abap_true ).  "Автоматическая оптимизация колонок

      lo_events = go_grid->get_event( ).
      SET HANDLER _on_double_click FOR lo_events.

      go_grid->display( ).
    CATCH cx_salv_msg ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD _on_double_click.

    READ TABLE gt_data ASSIGNING FIELD-SYMBOL(<l_line>) INDEX row.

    IF sy-subrc = 0.
      IF column = 'BANFN'.
        CALL TRANSACTION 'ME23N' WITHOUT AUTHORITY-CHECK.
      ENDIF.

      IF column = 'EBELN'.
        CALL TRANSACTION 'VA03' WITHOUT AUTHORITY-CHECK AND SKIP FIRST SCREEN.
      ENDIF.

      IF column = 'BELNR'.
        CALL TRANSACTION 'MIRO' WITHOUT AUTHORITY-CHECK.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.