
CLASS lcx_exception DEFINITION
*  PUBLIC
  INHERITING FROM cx_static_check
  CREATE public.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF no_bc_selected,
        msgid TYPE symsgid      VALUE 'ZC',
        msgno TYPE symsgno      VALUE '111',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_bc_selected.

    METHODS constructor
      IMPORTING textid    LIKE if_t100_message=>t100key OPTIONAL
                !previous LIKE previous                 OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcx_exception IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
