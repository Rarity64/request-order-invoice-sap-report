*&---------------------------------------------------------------------*
*& Report  Z_TEST_SUYARGULOV
*&
*&---------------------------------------------------------------------*
*& ����� �� ������ ������\�����\�������
*&
*&---------------------------------------------------------------------*

REPORT z_test_suyargulov.

INCLUDE z_test_suyargulov_dat.
INCLUDE z_test_suyargulov_scr.
INCLUDE z_test_suyargulov_cld.
INCLUDE z_test_suyargulov_cli.

START-OF-SELECTION.
  TRY.
    DATA(lo_data) = NEW lcl_app( ).
    lo_data->start( ).
  CATCH zcx_reca INTO DATA(go_error) ##NEEDED.
    MESSAGE go_error TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.
END-OF-SELECTION.