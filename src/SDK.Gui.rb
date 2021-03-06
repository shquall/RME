# -*- coding: utf-8 -*-
#==============================================================================
# ** RME V1.0.0
#------------------------------------------------------------------------------
#  With :
# Grim (original project)
# Nuki (a lot of things)
# Raho (general reformulation)
# Zeus81 (a lot of help)
# Hiino (some help and GUI Components)
# Joke (some help)
# Zangther (some help)
# XHTMLBoy (koffie)
# Fabien (Buzzer)
# Kaelar (Improvement)
#
#==============================================================================

=begin

License coming soon

=end

#==============================================================================
# ** GUI
#------------------------------------------------------------------------------
#  Graphical User interface
#==============================================================================

module Gui

  #==============================================================================
  # ** GUI::Tools
  #------------------------------------------------------------------------------
  #  Graphical User interface helpers
  #==============================================================================

  module Tools

    class << self
      def random_color
        Color.new(rand(255), rand(255), rand(255))
      end
    end

    module Activable
      def actived?
        @active
      end
      def activate
        @active = true
      end
      def deactivate
        @active = false
      end
      def trigger_activation
        @active = !@active
      end
      def activation_callback
        @activation_callback
      end
      def set_activation_callback(&block)
        @activation_callback = lambda{|s| false}
        @activation_callback = block if block_given?
      end
      def check_callback
        if @activation_callback
          if @activation_callback.call(self)
            @active = true
          end
        end
      end
    end

  end

  #==============================================================================
  # ** GUI::Components
  #------------------------------------------------------------------------------
  #  Graphical User interface components
  #==============================================================================

  module Components

    #==============================================================================
    # ** Text_Field
    #------------------------------------------------------------------------------
    #  IZI Things
    #==============================================================================

    class Text_Field
      #--------------------------------------------------------------------------
      # * IZI Public instance variables
      #--------------------------------------------------------------------------
      [
        :in?,
        :hover?,
        :click?,
        :press?,
        :trigger?,
        :repeat?,
        :release?,
        :mouse_x,
        :mouse_y,
        :>>,
        :<<,
        :dispose
      ].each{|m| delegate :@viewport, m}
      delegate_accessor :@text, :value
      delegate_accessor :@text, :virtual_position
      delegate_accessor :@text, :selection_start
      delegate :@text, :formatted_value
      delegate :@text, :has_transformation?
      delegate :@text, :delete
      [:x, :y].each{|m| delegate_accessor :@viewport, m}

      include Tools::Activable
      #--------------------------------------------------------------------------
      # * IZI Object initialize
      #--------------------------------------------------------------------------
      def initialize(textrecorder,x,y,w,font="Standard",active=false,&block)
        @active = active
        @text = textrecorder
        @x,@y,@w = x,y,w
        @font = get_profile(font).to_font
        @text.start_capture
        @cursor_timer = 0
        create_sprite
        create_viewport
        create_selection_rect
        create_cursor
        set_activation_callback(&block)
        update_bitmap
        update_cursor_pos
      end
      #--------------------------------------------------------------------------
      # * Refresh
      #--------------------------------------------------------------------------
      def refresh
        update_bitmap
        update_cursor_pos
        update_selection_rect
        update_viewport
      end
      #--------------------------------------------------------------------------
      # * IZI Update
      #--------------------------------------------------------------------------
      def update
        unless actived?
          @cursor.opacity = 0
          check_callback
        else
          locate if press?(:mouse_left) || Mouse.dragging? && in?(Mouse.drag.start)
          @text.update unless Devices::Keys::Enter.press? || Devices::Keys::Tab.press?
          update_bitmap if @text.has_transformation?
          if @text.cursor_has_moved?
            update_cursor_pos
            update_selection_rect
            update_viewport
          end
          update_cursor_blink
        end
      end
      #--------------------------------------------------------------------------
      # * IZI Sprite creation
      #--------------------------------------------------------------------------
      def create_sprite
        @sprite = Sprite.new
        @sprite.bitmap = Bitmap.new(1,1)
        @sprite.bitmap.font = @font
        @split_format = 640 / @sprite.bitmap.text_size("W").width
      end
      #--------------------------------------------------------------------------
      # * IZI Viewport creation
      #--------------------------------------------------------------------------
      def create_viewport
        @h = @sprite.bitmap.text_size("W").height
        @viewport = Viewport.new(@x,@y,@w,@h)
        @sprite.viewport = @viewport
      end
      #--------------------------------------------------------------------------
      # * IZI Cursor creation
      #--------------------------------------------------------------------------
      def create_cursor
        @cursor = Sprite.new(@viewport)
        @cursor.bitmap = Bitmap.new(1,@h)
        @cursor.bitmap.fill_rect(0,0,1,@h,Color.new(0,0,0))
        @cursor.ox = 1
      end
      def create_selection_rect
        @selection_rect = Sprite.new(@viewport)
        @selection_rect.bitmap = Bitmap.new(1,1)
        @selection_rect.bitmap.fill_rect(0,0,1,1,Color.new(51,153,255))
        @selection_rect.zoom_x = 0
        @selection_rect.zoom_y = @h
        @selection_rect.z = -1
      end
      #--------------------------------------------------------------------------
      # * IZI Bitmap update
      #--------------------------------------------------------------------------
      def update_bitmap
        text = value
        text = " " if text.empty?
        rect = @sprite.bitmap.text_size(text)
        @sprite.bitmap.dispose
        @sprite.bitmap = Bitmap.new(rect.width, rect.height)
        @sprite.bitmap.font = @font
        last_x = 0
        text.split_each(@split_format).each do |a_text|
          rect = @sprite.bitmap.text_size(a_text)
          rect.x = last_x
          @sprite.bitmap.draw_text(rect, a_text)
          last_x += rect.width
        end
      end
      #--------------------------------------------------------------------------
      # * IZI Cursor blink
      #--------------------------------------------------------------------------
      def update_cursor_blink
        @cursor_timer = (@cursor_timer + 1/20.0)%2
        @cursor.opacity = @cursor_timer < 1 ? 255 : 0
      end
      #--------------------------------------------------------------------------
      # * IZI Cursor position update
      #--------------------------------------------------------------------------
      def update_cursor_pos
        @cursor_timer = 0
        pos = @text.virtual_position
        if pos == 0
          @cursor.x = 1
        else
          @cursor.x = @sprite.bitmap.text_size(value[0...pos]).width
        end
      end
      #--------------------------------------------------------------------------
      # * IZI Selection Rect update
      #--------------------------------------------------------------------------
      def update_selection_rect
        pos = @text.selection_start
        if pos == 0
          @selection_rect.x = 1
        else
          @selection_rect.x = @sprite.bitmap.text_size(value[0...pos]).width
        end
        delta = @cursor.x - @selection_rect.x
        @selection_rect.zoom_x = delta.abs
        @selection_rect.x += delta if delta < 0
      end
      #--------------------------------------------------------------------------
      # * IZI Viewport update
      #--------------------------------------------------------------------------
      def update_viewport
        a = @cursor.x - @w
        b = @sprite.bitmap.width - @w
        @viewport.ox = @viewport.ox.bound(a, b).bound(0, @cursor.x-1)
      end
      #--------------------------------------------------------------------------
      # * IZI Cursor location on click
      #--------------------------------------------------------------------------
      def locate
        x = mouse_x + @viewport.ox
        approx = x * value.length / @sprite.bitmap.width
        match = approach(approx, x)
        @text.cursor_jump(match)
        @viewport.ox -= 10 if mouse_x < 0
        @viewport.ox += 10 if (@w - mouse_x) < 0
      end
      #--------------------------------------------------------------------------
      # * IZI Approach
      #--------------------------------------------------------------------------
      def approach(a, x, memoa=a, memob=0)
        bound = a.bound(0,value.length)
        return bound if bound != a
        b = @sprite.bitmap.text_size(value[0...a]).width
        return a if (b-x) == 0 || (b-x)==(x-memob)
        return memoa if (b-x).abs > (memob-x).abs
        approach(a + (0 <=> (b-x)), x, a, b)
      end

    end

    #==============================================================================
    # ** TextRecorder
    #------------------------------------------------------------------------------
    #  Record text state
    #==============================================================================

    class Abstract_Recorder
      #--------------------------------------------------------------------------
      # * Public instance variables
      #--------------------------------------------------------------------------
      attr_accessor :exit_keys
      attr_accessor :stopped
      attr_accessor :transformed
      attr_accessor :cursor_moved
      attr_accessor :virtual_position
      attr_accessor :selection_start
      alias_method :stopped?, :stopped
      def value=(v); @value = v; end
      def value; @value; end
      def formatted_value; @value; end

      #--------------------------------------------------------------------------
      # * Has a transformation
      #--------------------------------------------------------------------------
      def has_transformation?
        result = @transformed
        @transformed = false
        result
      end
      #--------------------------------------------------------------------------
      # * Cursor has moved
      #--------------------------------------------------------------------------
      def cursor_has_moved?
        result = @cursor_moved
        @cursor_moved = false
        result
      end
      #--------------------------------------------------------------------------
      # * Cursor jump
      #--------------------------------------------------------------------------
      def cursor_jump(v)
        @virtual_position = v
        bound_cursor
      end
      #--------------------------------------------------------------------------
      # * Start capture
      #--------------------------------------------------------------------------
      def start_capture
        @stopped = false
        update
      end
      #--------------------------------------------------------------------------
      # * Sop capture
      #--------------------------------------------------------------------------
      def stop_capture
        @stopped = true
      end
      #--------------------------------------------------------------------------
      # * Bound cursor position
      #--------------------------------------------------------------------------
      def bound_cursor
        @virtual_position = @virtual_position.bound(0, @value.length)
        @cursor_moved = true
        c = [nil, ''].include?(Keyboard.current_char)
        @selection_start = @virtual_position unless (Keyboard.shift && c || Mouse.dragging?)
      end
      #--------------------------------------------------------------------------
      # * go left
      #--------------------------------------------------------------------------
      def go_left
        @virtual_position -= 1
        bound_cursor
      end
      #--------------------------------------------------------------------------
      # * go Right
      #--------------------------------------------------------------------------
      def go_right
        @virtual_position += 1
        bound_cursor
      end
      #--------------------------------------------------------------------------
      # * Update key capture
      #--------------------------------------------------------------------------
      def update
        return if stopped?
        return stop_capture if @exit_keys.any?{|key| Keyboard.repeat?(key)}
        update_virtual_cursor
        update_value_modification
        update_value
        update_clipboard
      end
      #--------------------------------------------------------------------------
      # * Running
      #--------------------------------------------------------------------------
      def recording?
        !stopped?
      end
      #--------------------------------------------------------------------------
      # * Update text content
      #--------------------------------------------------------------------------
      def update_value
        return if @limit && @value.length >= @limit
        c = Keyboard.current_char
        unless [nil, ''].include?(c)
          delete(0)
          @value = @value.insert_at(@virtual_position, c)
          @transformed = true
          go_right
        end
      end
      #--------------------------------------------------------------------------
      # * Delete between
      #--------------------------------------------------------------------------
      def delete(dir=-1)
        range = [@virtual_position, @selection_start].sort
        if range[0] == range[1]
          return if @virtual_position == 0
          range[0] -= 1 if dir == -1
          range[1] += 1 if dir == 1
        end
        @value = @value.delete_between(*range)
        @virtual_position = @selection_start = range[0]
        @cursor_moved = @transformed = true
      end
      #--------------------------------------------------------------------------
      # * Update text content (bcps and del)
      #--------------------------------------------------------------------------
      def update_value_modification
        if Keyboard.krepeat?(0x08)
          delete
        end
        if Keyboard.krepeat?(0x2E)
          delete(1)
        end
      end
      #--------------------------------------------------------------------------
      # * Update cursor position
      #--------------------------------------------------------------------------
      def update_virtual_cursor
        go_left if Keyboard.krepeat?(0x25)
        go_right if Keyboard.krepeat?(0x27)
      end
      #--------------------------------------------------------------------------
      # * Update clipboard
      #--------------------------------------------------------------------------
      def update_clipboard
        if Keyboard.ctrl?(:c)
          c = value[Range.new(*[@selection_start, @virtual_position].sort,true)]
          Clipboard.push_text(c) unless c.empty?
        end
        if Keyboard.ctrl?(:x)
          c = value[Range.new(*[@selection_start, @virtual_position].sort,true)]
          Clipboard.push_text(c) unless c.empty?
          delete(0)
        end
        if Keyboard.ctrl?(:v)
          delete(0)
          c = Clipboard.get_text
          @value = @value.insert_at(@virtual_position, c)
          @virtual_position += c.length
          @transformed = true
          bound_cursor
        end
      end
    end

    #==============================================================================
    # ** TextRecorder
    #------------------------------------------------------------------------------
    #  Record text state
    #==============================================================================

    class Text_Recorder < Abstract_Recorder
      #--------------------------------------------------------------------------
      # * Object initialize
      #--------------------------------------------------------------------------
      def initialize(init = "", limit = nil , exit_keys = [])
        @transformed = true
        @stopped = true
        @exit_keys = exit_keys
        @limit = limit
        @value = init
        @value = init[0...@limit] if @limit
        @virtual_position = @selection_start = init.length
      end
    end

    #==============================================================================
    # ** Int_Recorder
    #------------------------------------------------------------------------------
    #  Record int state
    #==============================================================================

    class Int_Recorder < Abstract_Recorder
      #--------------------------------------------------------------------------
      # * Object initialize
      #--------------------------------------------------------------------------
      def initialize(init = 0, limit = nil , exit_keys = [])
        @transformed = true
        @stopped = true
        @exit_keys = exit_keys
        @limit = limit
        @value = init
        @value = init.bound(@limit.min, @limit.max) if @limit
        @value = @value.to_s
        @virtual_position = @selection_start = @value.length
      end
      #--------------------------------------------------------------------------
      # * Value accessor
      #--------------------------------------------------------------------------
      def formatted_value;
        self.value=@value
        @value.to_i
      end
      def value; @value; end
      def value=(v)
        return @value = v if v == '+' || v == '-'
        @value = v.to_i
        @value = @value.bound(@limit.min, @limit.max) if @limit
        @value = @value.to_s
        @virtual_position = @selection_start = @value.length
      end
      #--------------------------------------------------------------------------
      # * Update text content
      #--------------------------------------------------------------------------
      def update_value
        c = Keyboard.current_char
        unless [nil, ''].include?(c)
          delete(0)
          return unless (["+","-"] + ("0".."9").to_a).include?(c)
          return if @value != "" && ["+","-"].include?(c)
          self.value = @value.insert_at(@virtual_position, c)
          @transformed = true
          go_right
        end
      end
    end

    #==============================================================================
    # ** Int_Recorder
    #------------------------------------------------------------------------------
    #  Record int state
    #==============================================================================

    class Float_Recorder < Abstract_Recorder
      #--------------------------------------------------------------------------
      # * Object initialize
      #--------------------------------------------------------------------------
      def initialize(init = 0.0, limit = nil , exit_keys = [])
        @transformed = true
        @stopped = true
        @exit_keys = exit_keys
        @limit = limit
        @value = init
        @value = [[@limit.min,init].max, @limit.max].min  if @limit
        @value = @value.to_s
        @virtual_position = @selection_start = @value.length
      end
      #--------------------------------------------------------------------------
      # * Value accessor
      #--------------------------------------------------------------------------
      def formatted_value;
        self.value=@value
        @value.to_f
      end
      def value; @value; end
      def value=(v)
        return @value = v if v == '+' || v == '-' || v == '.'
        @value = v.to_s
        if @limit
          result = @value.to_f
          unless @limit.member?(result)
            @value = [[@limit.min,result].max, @limit.max].min.to_s
          end
        end
        @virtual_position = @selection_start = @value.to_s.length
      end
      #--------------------------------------------------------------------------
      # * Update text content
      #--------------------------------------------------------------------------
      def update_value
        c = Keyboard.current_char
        unless [nil, ''].include?(c)
          delete(0)
          return unless (["+","-",'.'] + ("0".."9").to_a).include?(c)
          return if @value != "" && ["+","-"].include?(c)
          return if c == "." && @value.count(".") == 1
          self.value = @value.insert_at(@virtual_position, c)
          @transformed = true
          go_right
        end
      end
    end

  end


end
