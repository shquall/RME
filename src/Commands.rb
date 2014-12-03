# -*- coding: utf-8 -*-
#==============================================================================
# ** RME V1.0.0 Commands
#------------------------------------------------------------------------------
#  With : 
# Grim (original project)
# Nuki 
# Raho
#  Help :
# Fabien
# Zeus81
# Joke 
# Zangther
#------------------------------------------------------------------------------
# Commands API
# Provide all commands of the EvEx
#==============================================================================

module RMECommands

  #--------------------------------------------------------------------------
  # * Public Commands
  #--------------------------------------------------------------------------
  def screen; Game_Screen.get; end
  def pictures; screen.pictures; end
  def scene; SceneManager.scene; end
  def wait(d); d.times {Fiber.yield}; end
  def session_username; USERNAME; end
  def length(a); a.length; end
  def get(a, i); a[i]; end
  def event(id);(id < 1) ? $game_player : $game_map.events[id]; end

  append_commands
  
  #==============================================================================
  # ** Parallaxes
  #------------------------------------------------------------------------------
  #  Parallaxes Commands
  #==============================================================================
  module Parallaxes
     #--------------------------------------------------------------------------
    # * Show parallax
    #--------------------------------------------------------------------------
    def parallax_show(
        id, 
        name, 
        z  = -100, 
        op = 255, 
        ax = 0, 
        ay = 0, 
        mx = 2, 
        my = 2, 
        b  = 0, 
        zx = 100, 
        zy = 100
      )
      $game_map.parallaxes[id].show(name, z, op, ax, ay, mx, my, b, zx, zy)
    end
    #--------------------------------------------------------------------------
    # * Move parallax
    #--------------------------------------------------------------------------
    def parallax_transform(
        id, 
        duration, 
        wf = false, 
        zoom_x = 100, 
        zoom_y = 100, 
        opacity = 255, 
        tone = nil
      )
      $game_map.parallaxes[id].move(duration, zoom_x, zoom_y, opacity, tone)
      wait(duration) if wf
    end
    #--------------------------------------------------------------------------
    # * Hide parallax
    #--------------------------------------------------------------------------
    def parallax_erase(id)
      $game_map.parallaxes[id].hide
    end
    #--------------------------------------------------------------------------
    # * Hide all parallax
    #--------------------------------------------------------------------------
    def parallaxes_clear
      $game_map.clear_parallaxes
    end
    #--------------------------------------------------------------------------
    # * Change blend type of a parallax
    #--------------------------------------------------------------------------
    def parallax_blend(id, v)
      $game_map.parallaxes[id].blend_type = v
    end
    #--------------------------------------------------------------------------
    # * Change autospeed_x 
    #--------------------------------------------------------------------------
    def parallax_autoscroll_x(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.start_auto_change(v.to_f, pr.autospeed_y, duration)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].autospeed_x = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change autospeed_x 
    #--------------------------------------------------------------------------
    def parallax_autoscroll_y(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.start_auto_change(pr.autospeed_x, v.to_f, duration)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].autospeed_y = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change scroll_x
    #--------------------------------------------------------------------------
    def parallax_scroll_x(id, v)
      $game_map.parallaxes[id].move_x = v
    end
    #--------------------------------------------------------------------------
    # * Change scroll_y
    #--------------------------------------------------------------------------
    def parallax_scroll_y(id, v)
      $game_map.parallaxes[id].move_y = v
    end
    #--------------------------------------------------------------------------
    # * Change zoom_x
    #--------------------------------------------------------------------------
    def parallax_zoom_x(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.move(duration, v, pr.zoom_y, pr.opacity)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].zoom_x = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change zoom_y
    #--------------------------------------------------------------------------
    def parallax_zoom_y(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.move(duration, pr.zoom_x, v, pr.opacity)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].zoom_y = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change zoom
    #--------------------------------------------------------------------------
    def parallax_zoom(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.move(duration, v, v, pr.opacity)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].zoom_y = v
        $game_map.parallaxes[id].zoom_x = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change tone
    #--------------------------------------------------------------------------
    def parallax_tone(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.move(duration, pr.zoom_x, pr.zoom_y, pr.opacity, v)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].tone = v
      end
    end
    #--------------------------------------------------------------------------
    # * Change opacity
    #--------------------------------------------------------------------------
    def parallax_opacity(id, v, duration = nil, wf = false)
      if duration.is_a?(Fixnum)
        pr = $game_map.parallaxes[id]
        pr.move(duration, pr.zoom_x, pr.zoom_y, v)
        wait(duration) if wf
      else
        $game_map.parallaxes[id].opacity = v
      end
    end
    append_commands
  end

  #==============================================================================
  # ** Commands Picture
  #------------------------------------------------------------------------------
  #  Pictures manipulation
  #==============================================================================

  module Pictures
    #--------------------------------------------------------------------------
    # * Spriteset
    #--------------------------------------------------------------------------
    def spriteset
      scene.spriteset
    end
    #--------------------------------------------------------------------------
    # * Sprite picture
    #--------------------------------------------------------------------------
    def sprite_picture(id)
      spriteset.picture_sprites[id]
    end
    #--------------------------------------------------------------------------
    # * Picture show
    #--------------------------------------------------------------------------
    def picture_show(id, n, x=0, y=0, ori=0,  z_x=100, z_y=100, op=255, bl=0)
      pictures[id].show(n, ori, x, y, z_x, z_y, op, bl)
    end
    #--------------------------------------------------------------------------
    # * Picture erase
    #--------------------------------------------------------------------------
    def picture_erase(id)
      pictures[id].erase
    end
    #--------------------------------------------------------------------------
    # * Modify Origin
    # Origin : 0 | 1 (0 = Corner High Left, 1 = Center)
    #--------------------------------------------------------------------------
    def picture_origin(id, *origin)
      origin = origin[0] if origin.length == 1
      pictures[id].origin = origin
    end
    #--------------------------------------------------------------------------
    # * Modify x position
    #--------------------------------------------------------------------------
    def picture_x(id, x=false)
      return pictures[id].x unless x
      pictures[id].x = x
    end
    #--------------------------------------------------------------------------
    # * Modify y position
    #--------------------------------------------------------------------------
    def picture_y(id, y=false)
      return pictures[id].y unless y
      pictures[id].y = y
    end
    #--------------------------------------------------------------------------
    # * Modify position
    #--------------------------------------------------------------------------
    def picture_position(id, x, y)
      picture_x(id, x)
      picture_y(id, y)
    end
    #--------------------------------------------------------------------------
    # * Move picture
    #--------------------------------------------------------------------------
    def picture_move(id, x, y, zoom_x, zoom_y, dur, wf = true, opacity = -1, bt = -1, o = -1)
      p = pictures[id]
      opacity = (opacity == -1) ? p.opacity : opacity
      blend = (bt == -1) ? p.blend_type : bt
      origin = (o == -1) ? p.origin : o
      p.move(origin, x, y, zoom_x, zoom_y, opacity, blend, dur)
      wait(dur) if wf
    end
    #--------------------------------------------------------------------------
    # * Modify wave
    #--------------------------------------------------------------------------
    def picture_wave(id, amp, speed)
      pictures[id].wave_amp = amp
      pictures[id].wave_speed = speed
    end
    #--------------------------------------------------------------------------
    # * Apply Mirror
    #--------------------------------------------------------------------------
    def picture_flip(id)
      pictures[id].mirror = !pictures[id].mirror
    end
    #--------------------------------------------------------------------------
    # * Modify Angle
    #--------------------------------------------------------------------------
    def picture_angle(id, angle=false)
      return pictures[id].angle unless angle
      pictures[id].angle = angle%360
    end
    #--------------------------------------------------------------------------
    # * Rotate
    #--------------------------------------------------------------------------
    def picture_rotate(id, speed)
      pictures[id].rotate(speed)
    end
    #--------------------------------------------------------------------------
    # * change Zoom X
    #--------------------------------------------------------------------------
    def picture_zoom_x(id, zoom_x=false)
      return pictures[id].zoom_x unless zoom_x
      pictures[id].zoom_x = zoom_x
    end
    #--------------------------------------------------------------------------
    # * change Zoom Y
    #--------------------------------------------------------------------------
    def picture_zoom_y(id, zoom_y=false)
      return pictures[id].zoom_y unless zoom_y
      pictures[id].zoom_y = zoom_y
    end
    #--------------------------------------------------------------------------
    # * change Zoom
    #--------------------------------------------------------------------------
    def picture_zoom(id, zoom_x, zoom_y = -1)
      zoom_y = zoom_x if zoom_y == -1
      picture_zoom_x(id, zoom_x)
      picture_zoom_y(id, zoom_y)
    end
    #--------------------------------------------------------------------------
    # * change Tone
    #--------------------------------------------------------------------------
    def picture_tone(id, tone, d = nil, wf = false)
      if d.is_a?(Fixnum)
        pictures[id].start_tone_change(tone, d)
        wait(d) if wf
      else
        pictures[id].tone = tone
      end
    end
    #--------------------------------------------------------------------------
    # * Change blend type
    #--------------------------------------------------------------------------
    def picture_blend(id, blend)
      pictures[id].blend = blend
    end
    #--------------------------------------------------------------------------
    # * Pin picture on the map
    #--------------------------------------------------------------------------
    def picture_pin(id, x, y)
      picture_x(id, x)
      picture_y(id, y)
      pictures[id].pin
    end
    #--------------------------------------------------------------------------
    # * Unpin picture on the map
    #--------------------------------------------------------------------------
    def picture_unpin(id)
      pictures[id].unpin
    end
    #--------------------------------------------------------------------------
    # * Change Picture Opacity
    #--------------------------------------------------------------------------
    def picture_opacity(id, value)
      pictures[id].opacity = value
    end
    #--------------------------------------------------------------------------
    # * Shake the picture
    #--------------------------------------------------------------------------
    def picture_shake(id, power, speed, duration)
      pictures[id].start_shake(power, speed, duration)
    end
    #--------------------------------------------------------------------------
    # * Point in picture
    #--------------------------------------------------------------------------
    def pixel_in_picture?(id, x, y, precise = false)
      spr = sprite_picture(id)
      return false unless spr
      if spr.angle != 0
        a = spr.angle * Math::PI/180
        c, s = Math.cos(a), Math.sin(a)
        x, y = x-spr.x, y-spr.y
        x, y = (x*c - y*s).to_i, (x*s + y*c).to_i
        x, y = x+spr.x, y+spr.y
      end
      precise ? spr.precise_in?(x, y) : spr.in?(x, y)
    end
    #--------------------------------------------------------------------------
    # * Picture collisions
    #--------------------------------------------------------------------------
    def pictures_collide?(a, b)
      spr_a = sprite_picture(a)
      spr_b = sprite_picture(b)
      return if (!spr_a) || (!spr_b)
      spr_a.collide_with?(spr_b)
    end
    #--------------------------------------------------------------------------
    # * Picture collisions (perfect pixel)
    #--------------------------------------------------------------------------
    def pictures_perfect_collide?(a, b)
      spr_a = sprite_picture(a)
      spr_b = sprite_picture(b)
      return if (!spr_a) || (!spr_b)
      spr_a.pixel_collide_with(spr_b)
    end
    #--------------------------------------------------------------------------
    # * Change scroll speed (in X)
    #--------------------------------------------------------------------------
    def picture_scroll_x(id, speed)
      pictures[id].scroll_speed_x = speed
    end
    #--------------------------------------------------------------------------
    # * Change scroll speed (in Y)
    #--------------------------------------------------------------------------
    def picture_scroll_y(id, speed)
      pictures[id].scroll_speed_y = speed
    end
    #--------------------------------------------------------------------------
    # * Change scroll speed
    #--------------------------------------------------------------------------
    def picture_scroll(id, speed)
      picture_scroll_x(id, speed)
      picture_scroll_y(id, speed)
    end
    #--------------------------------------------------------------------------
    # * Clear all pictures
    #--------------------------------------------------------------------------
    def pictures_clear
      screen.clear_pictures
    end

  append_commands
  end

  #==============================================================================
  # ** Commands Base
  #------------------------------------------------------------------------------
  #  Basics Commands
  #==============================================================================

  module Std
    #--------------------------------------------------------------------------
    # * Random number from a range
    #--------------------------------------------------------------------------
    def random(min=0, max)
      min, max = [min.to_i, max.to_i].sort
      min + Kernel.rand(max-min+1)
    end
    #--------------------------------------------------------------------------
    # * Random floating point value between x and its successor
    #--------------------------------------------------------------------------
    def random_figures(x=0)
      x + Kernel.rand
    end
    #--------------------------------------------------------------------------
    # * Return ID of current map
    #--------------------------------------------------------------------------
    def map_id
      $game_map.map_id
    end
    #--------------------------------------------------------------------------
    # * Return map's name
    #--------------------------------------------------------------------------
    def map_name
      $game_map.display_name
    end
    #--------------------------------------------------------------------------
    # * Get Event Id form coords
    #--------------------------------------------------------------------------
    def id_at(x, y)
      result = $game_map.event_id_xy(x, y)
      return result if result > 0
      return 0 if $game_player.x == x && $game_player.y == y
      return -1
    end
    #--------------------------------------------------------------------------
    # * Get terrain Tag from coords
    #--------------------------------------------------------------------------
    def terrain_tag(x, y)
      $game_map.terrain_tag(x, y)
    end
    #--------------------------------------------------------------------------
    # * Get Tile ID from coords and layer (0,1,2)
    #--------------------------------------------------------------------------
    def tile_id(x, y, layer)
      $game_map.tile_id(x, y, layer)
    end
    #--------------------------------------------------------------------------
    # * Get Region ID from coords
    #--------------------------------------------------------------------------
    def region_id(x, y)
      $game_map.region_id(x, y)
    end
    #--------------------------------------------------------------------------
    # * Check passability
    #--------------------------------------------------------------------------
    def square_passable?(x, y, d=2)
      $game_map.passable?(x, y, d)
    end
    #--------------------------------------------------------------------------
    # * Get a percent
    #--------------------------------------------------------------------------
    def percent(value, max)
      ((value*100.0)/max).to_i
    end
    #--------------------------------------------------------------------------
    # * Get a value from a percent
    #--------------------------------------------------------------------------
    def apply_percent(percent, max)
      ((percent*max)/100.0).to_i
    end
    #--------------------------------------------------------------------------
    # * Include event page
    #--------------------------------------------------------------------------
    def include_page(map_id, ev_id, p_id, if_runnable = false, context=false)
      return unless self.class == Game_Interpreter
      page = Game_Interpreter.get_page(map_id, ev_id, p_id)
      return unless page
      if !if_runnable || page_runnable?(map_id, ev_id, page, context)
        self.append_interpreter(page)
      end
    end
    #--------------------------------------------------------------------------
    # * Invoke Event
    #--------------------------------------------------------------------------
    def invoke_event(map_id, ev_id, new_id, x=nil, y=nil)
      $game_map.add_event(map_id, ev_id, new_id, x, y)
    end
    #--------------------------------------------------------------------------
    # * Get the max Event ID
    #--------------------------------------------------------------------------
    def max_event_id; $game_map.max_id; end
    def fresh_event_id; max_event_id + 1; end
    #--------------------------------------------------------------------------
    # * Check if a page is runnable
    #--------------------------------------------------------------------------
    def page_runnable?(map_id, ev_id, page, context=false)
      return unless self.class == Game_Interpreter
      page = Game_Interpreter.get_page(map_id, ev_id, p_id) if page.is_a?(Fixnum)
      return unless page
      return Game_Interpreter.conditions_met?(map_id, ev_id, page) if context
      c_map_id = Game_Interpreter.current_map_id
      c_ev_id = self.event_id
      Game_Interpreter.conditions_met?(c_map_id, c_ev_id, page)
    end
    #--------------------------------------------------------------------------
    # * Create a tone
    #--------------------------------------------------------------------------
    def tone(r, v, b, gray = 0)
      Tone.new(r, v, b, gray)
    end
    #--------------------------------------------------------------------------
    # * Create a Color
    #--------------------------------------------------------------------------
    def color(r, v, b, a = 255)
      Color.new(r,v,b,a)
    end

    append_commands
  end

  #==============================================================================
  # ** Commands Device
  #------------------------------------------------------------------------------
  #  Device commands
  #==============================================================================

  module Device
    #--------------------------------------------------------------------------
    # * Keyboard support
    #--------------------------------------------------------------------------
    def key_press?(k);        Keyboard.press?(k);             end
    def key_trigger?(k);      Keyboard.trigger?(k);           end
    def key_release?(k);      Keyboard.release?(k);           end
    def key_repeat?(k);       Keyboard.repeat?(k);            end
    def ctrl?(k=nil);         Keyboard.ctrl?(k);              end
    def keyboard_all?(m, *k); Keyboard.all?(m, *k);           end
    def keyboard_any?(m, *k); Keyboard.any?(m, *k);           end
    def caps_lock?;           Keyboard.caps_lock?;            end
    def num_lock?;            Keyboard.num_lock?;             end
    def scroll_lock?;         Keyboard.scroll_lock?;          end
    def shift?;               Keyboard.shift?;                end
    def alt_gr?;              Keyboard.alt_gr?;               end
    def key_time(k);          Keyboard.time(k);               end
    def key_current(*m);      Keyboard.current_key(*m);       end
    def key_current_rgss(*m); Keyboard.rgss_current_key(*m);  end
    def keyboard_current_digit; Keyboard.current_digit;         end
    def keyboard_current_char;  Keyboard.current_char;          end
    #--------------------------------------------------------------------------
    # * Mouse Support
    #--------------------------------------------------------------------------
    def mouse_press?(k);    Mouse.press?(k);                end
    def mouse_click?;       Mouse.click?;                   end
    def mouse_trigger?(k);  Mouse.trigger?(k);              end
    def mouse_release?(k);  Mouse.release?(k);              end
    def mouse_dragging?;    Mouse.dragging?;                end
    def mouse_repeat?(k);   Mouse.repeat?(k);               end
    def mouse_all?(m, *k);  Mouse.all?(m, *k);              end
    def mouse_any?(m, *k);  Mouse.any?(m, *k);              end
    def mouse_x;            Mouse.x;                        end
    def mouse_y;            Mouse.y;                        end
    def mouse_point;        Mouse.point;                    end 
    def mouse_square_x;     Mouse.square_x;                 end
    def mouse_square_y;     Mouse.square_y;                 end
    def mouse_rect;         Mouse.rect;                     end
    def mouse_last_rect;    Mouse.last_rect;                end
    def click_time(k);      Mouse.time(k);                  end
    def mouse_in?(rect);    Mouse.in?(rect);                end
    def mouse_current_key(*m)   Mouse.current_key(*m);      end
    append_commands
  end

  #==============================================================================
  # ** Commands Team
  #------------------------------------------------------------------------------
  #  Team Commands
  #==============================================================================

  module Party
    #--------------------------------------------------------------------------
    # * Party data
    #--------------------------------------------------------------------------
    def team_size; $game_party.members.size; end
    def gold; $game_party.gold; end
    def steps; $game_party.steps; end
    def play_time; (Graphics.frame_count / Graphics.frame_rate); end
    def timer; $game_timer.sec; end
    def save_count; $game_system.save_count; end
    def battle_count; $game_system.battle_count; end
    def gain_gold(amount); $game_party.gain_gold(amount); end
    def lose_gold(amount); $game_party.lose_gold(amount); end
    #--------------------------------------------------------------------------
    # * Items
    #--------------------------------------------------------------------------
    def item_count(id); $game_party.item_number($data_items[id]); end
    def weapon_count(id); $game_party.item_number($data_weapons[id]); end
    def armor_count(id); $game_party.item_number($data_armors[id]); end
    def item_name(id); $data_items[id].name; end
    def weapon_name(id); $data_weapons[id].name; end
    def armor_name(id); $data_armors[id].name; end
    def item_note(id); $data_items[id].note; end
    def weapon_note(id); $data_weapons[id].note; end
    def armor_note(id); $data_armors[id].note; end
    def item_description(id); $data_items[id].description; end
    def weapon_description(id); $data_weapons[id].description; end
    def armor_description(id); $data_armors[id].description; end
    def item_icon(id); $data_items[id].icon_index; end
    def weapon_icon(id); $data_weapons[id].icon_index; end
    def armor_icon(id); $data_armors[id].icon_index; end
    def item_price(id); $data_items[id].price; end
    def weapon_price(id); $data_weapons[id].price; end
    def armor_price(id); $data_armors[id].price; end
    def item_consumable?(id); $data_items[id].consumable; end
    def is_key_item?(id); $data_items[id].key_item?; end
    def weapon_max_hit_points(id); $data_weapons[id].params[0]; end
    def weapon_max_magic_points(id); $data_weapons[id].params[1]; end
    def weapon_attack_power(id); $data_weapons[id].params[2]; end
    def weapon_defense_power(id); $data_weapons[id].params[3]; end
    def weapon_magic_attack_power(id); $data_weapons[id].params[4]; end
    def weapon_magic_defense_power(id); $data_weapons[id].params[5]; end
    def weapon_agility(id); $data_weapons[id].params[6]; end
    def weapon_luck(id); $data_weapons[id].params[7]; end
    def armor_max_hit_points(id); $data_armors[id].params[0]; end
    def armor_max_magic_points(id); $data_armors[id].params[1]; end
    def armor_attack_power(id); $data_armors[id].params[2]; end
    def armor_defense_power(id); $data_armors[id].params[3]; end
    def armor_magic_attack_power(id); $data_armors[id].params[4]; end
    def armor_magic_defense_power(id); $data_armors[id].params[5]; end
    def armor_agility(id); $data_armors[id].params[6]; end
    def armor_luck(id); $data_armors[id].params[7]; end

    def give_item(id, amount)
      item = $data_items[id];
      $game_party.gain_item(item, amount, include_equip)
    end
    def give_weapon(id, amount, include_equip = false)
      item = $data_weapons[id];
      $game_party.gain_item(item, amount, include_equip)
    end
    def give_armor(id, amount, include_equip = false)
      item = $data_armors[id];
      $game_party.gain_item(item, amount, include_equip)
    end
    def has_item?(id)
      item = $data_items[id]
      $game_party.has_item?(item)
    end
    def has_weapon?(id, include_equip = false)
      item = $data_weapons[id]
      $game_party.has_item?(item, include_equip)
    end
    def has_armor?(id, include_equip = false)
      item = $data_armors[id]
      $game_party.has_item?(item, include_equip)
    end
    def weapon_equiped?(id, member = nil)
      item = $data_weapons[id]
      return $game_party.members_equip_include?(item) unless member
      $game_actors[member].equips.include?(item)
    end
    def armor_equiped?(id, member = nil)
      item = $data_armors[id]
      return $game_party.members_equip_include?(item) unless member
      $game_actors[member].equips.include?(item)
    end
    
    def weapon_type(id)
     i = $data_weapons[id].wtype_id
     $data_system.weapon_types[i]
    end
    def armor_type(id)
      i = $data_armors[id].atype_id
      $data_system.armor_types[i]
    end
    def item_scope(id)
      $data_items[id].scope
    end
    def item_has_no_scope?(id)
      item_scope(id) == 0
    end
    def item_for_one_enemy?(id)
      item_scope(id) == 1
    end
    def item_for_all_enemies?(id)
      item_scope(id) == 2
    end
    def item_for_one_random_enemy?(id)
      item_scope(id) == 3
    end
    def item_for_two_random_enemy?(id)
      item_scope(id) == 4
    end
    def item_for_three_random_enemy?(id)
      item_scope(id) == 5
    end
    def item_for_four_random_enemy?(id)
      item_scope(id) == 6
    end
    def item_for_one_ally?(id)
      item_scope(id) == 7
    end
    def item_for_all_allies?(id)
      item_scope(id) == 8
    end
    def item_for_one_dead_ally?(id)
      item_scope(id) == 9
    end
    def item_for_all_dead_allies?(id)
      item_scope(id) == 10
    end
    def item_for_caller?(id)
      item_scope(id) == 11
    end
    def item_occasion(id)
      $data_items[id].occasion
    end
    def item_always_usable?(id)
      item_occasion(id) == 0
    end
    def item_battle_usable?(id)
      item_always_usable?(id) || item_occasion(id) == 1
    end
    def item_menu_usable?(id)
      item_always_usable?(id) || item_occasion(id) == 2
    end
    def item_never_usable?(id)
      item_occasion(id) == 3 
    end
    def item_for_oponent?(i); $data_items[i].for_opponent?; end
    def item_for_friend?(i); $data_items[i].for_friend?; end 
    def item_for_dead_friend?(i); $data_items[i].for_dead_friend?; end 
    def item_for_one?(i); $data_items[i].for_one?; end 
    def item_for_random?(i); $data_items[i].for_random?; end 
    def item_for_all?(i); $data_items[i].for_all?; end 
    def item_need_selection?(i); $data_items[i].need_selection?; end 
    def item_certain?(i); $data_items[i].certain?; end 
    def item_physical?(i); $data_items[i].physical?; end 
    def item_magical?(i); $data_items[i].magical?; end 
    def item_number_of_targets(i); $data_items[i].number_of_targets; end 
    def item_speed(i); $data_items[i].speed; end 
    def item_nb_hits(i); $data_items[i].repeats; end 
    def item_success_rate(i); $data_items[i].success_rate; end
    def item_tp_gain(i); $data_items[i].tp_gain; end

    append_commands
  end

  #==============================================================================
  # ** Commands System
  #------------------------------------------------------------------------------
  #  System Commands
  #==============================================================================

  module System
    def sys; $data_system; end
    def game_title; sys.game_title; end
    def version_id; sys.version_id; end
    def currency; sys.currency_unit; end
    def start_map_id; sys.start_map_id; end
    def start_x; sys.start_x; end 
    def start_y; sys.start_y; end
    append_commands
  end

  #==============================================================================
  # ** Database  Actor reader
  #------------------------------------------------------------------------------
  #  DatabaseActor commands
  #==============================================================================

  module Actors
    def type_equip(str)
      [:Weapon, :Shield, :Head, :Body, :Accessory].index(str)
    end
    def actor_equip(id, t)
      k = $game_actors[id].equips[type_equip(t)]
      (k.nil?) ? 0 : k.id
    end
    def actor_weapon(id); actor_equip(id, :Weapon); end 
    def actor_shield(id); actor_equip(id, :Shield); end 
    def actor_head(id); actor_equip(id, :Head); end 
    def actor_body(id); actor_equip(id, :Body); end 
    def actor_description(id); $game_actors[id].description; end
    def actor_accessory(id); actor_equip(id, :Accessory); end
    def actor_has_weapon?(id); actor_weapon(id) != 0; end 
    def actor_has_shield?(id); actor_shield(id) != 0; end 
    def actor_has_head?(id); actor_head(id) != 0; end 
    def actor_has_body?(id); actor_body(id) != 0; end 
    def actor_has_accessory?(id); actor_accessory(id) != 0; end 
    def actor_level(id); $game_actors[id].level; end
    def actor_level_max(id); $game_actors[id].max_level; end
    def actor_exp(id); $game_actors[id].exp; end
    def actor_note(id);  $game_actors[id].actor.note; end
    def actor_hp(id); $game_actors[id].hp; end 
    def actor_mp(id); $game_actors[id].mp; end 
    def actor_tp(id); $game_actors[id].tp; end 
    def actor_max_hp(id); $game_actors[id].mhp; end 
    def actor_max_mp(id); $game_actors[id].mmp; end 
    def actor_attack(id); $game_actors[id].atk; end 
    def actor_defense(id); $game_actors[id].def; end 
    def actor_magic_attack(id); $game_actors[id].mat; end 
    def actor_magic_defense(id); $game_actors[id].mdf; end 
    def actor_agility(id); $game_actors[id].agi; end 
    def actor_luck(id); $game_actors[id].luk; end
    def actor_hit_rate(id); $game_actors[id].hit; end
    def actor_evasion_rate(id); $game_actors[id].eva; end
    def actor_critical_rate(id); $game_actors[id].cri; end 
    def actor_critical_evasion_rate(id); $game_actors[id].cev; end 
    def actor_magical_evasion_rate(id); $game_actors[id].mev; end 
    def actor_magical_reflection_rate(id); $game_actors[id].mrf; end 
    def actor_counter_attack_rate(id); $game_actors[id].cnt; end 
    def actor_hp_regeneration_rate(id); $game_actors[id].hrg; end 
    def actor_mp_regeneration_rate(id); $game_actors[id].mrg; end 
    def actor_tp_regeneration_rate(id); $game_actors[id].trg; end 
    def actor_target_rate(id); $game_actors[id].tgr; end 
    def actor_guard_effect_rate(id); $game_actors[id].grd; end 
    def actor_recovery_effect_rate(id); $game_actors[id].rec; end 
    def actor_pharmacology(id); $game_actors[id].pha; end 
    def actor_mp_cost_rate(id); $game_actors[id].mcr; end 
    def actor_tp_charge_rate(id); $game_actors[id].tcr; end 
    def actor_physical_damage_rate(id); $game_actors[id].pdr; end 
    def actor_magical_damage_rate(id); $game_actors[id].mdr; end 
    def actor_floor_damage_rate(id); $game_actors[id].fdr; end
    def actor_experience_rate(id); $game_actors[id].exr; end 
    def actor_name(id); $game_actors[id].name; end
    def set_actor_name(id, n); $game_actors[id].name = n; end
    def actor_nickname(id); $game_actors[id].nickname; end
    def set_actor_nickname(id, n); $game_actors[id].nickname = n; end
    def actor_character_name(id); $game_actors[id].character_name; end
    def actor_character_index(id); $game_actors[id].character_index; end
    def actor_face_name(id); $game_actors[id].face_name; end
    def actor_face_index(id); $game_actors[id].face_index; end
    def actor_class(id); $game_actors[id].class_id; end
    def actor_exp_for_next_level(id); $game_actors[id].next_level_exp; end
    def actor_change_equip(id, slot, wp_id)
      $game_actors[id].change_equip_by_id(type_equip(slot), wp_id)
    end
    def actor_equip_weapon(id, wp); actor_equip(id, :Weapon, wp_id); end 
    def actor_equip_shield(id, wp); actor_equip(id, :Shield, wp_id); end 
    def actor_equip_head(id, wp); actor_equip(id, :Head, wp_id); end 
    def actor_equip_body(id, wp); actor_equip(id, :Body, wp_id); end 
    def actor_equip_accessory(id, wp); actor_equip(id, :Accessory, wp_id); end 
    def actor_optimize_equipement(id); $game_actors[id].optimize_equipement; end
    def actor_level_up(id); $game_actors[id].level_up; end
    def actor_level_down(id); $game_actors[id].level_down; end
    def actor_give_exp(id, exp); $game_actors[id].gain_exp(exp); end
    def actor_learn(id, skill_id); $game_actors[id].learn_skill(skill_id); end
    def actor_forget(id, skill_id); $game_actors[id].forget_skill(skill_id); end
    def actor_knowns?(id, skill_id); $game_actors[id].learn_skill?(skill_id); end
    def actor_set_graphic(character_name, character_index, face_name, face_index)
      $game_actors.set_graphic(character_name, character_index, face_name, face_index)
    end
    def actor_skills(id); $game_actors[id].skills.map{|s| s.id}; end
    def actor_weapons(id); $game_actors[id].weapons.map{|w| w.id}; end
    def actor_armors(id); $game_actors[id].armors.map{|a| a.id}; end
    append_commands
  end


  #==============================================================================
  # ** Events positions
  #------------------------------------------------------------------------------
  #  Events positions commands
  #==============================================================================

  module Events
    def event_x(id); event(id).x; end
    def event_y(id); event(id).y; end
    def event_screen_x(id); event(id).screen_x; end
    def event_screen_y(id); event(id).screen_y; end
    def event_pixel_y(id) 
      ($game_map.display_y * 32) + event_screen_y(id)
    end
    def event_pixel_x(id) 
      ($game_map.display_x * 32) + event_screen_x(id)
    end
    def event_direction(id); event(id).direction; end
    def player_x; event(0).x; end
    def player_y; event(0).y; end
    def player_screen_x; event(0).screen_x; end
    def player_screen_y; event(0).screen_y; end
    def player_pixel_x; event_pixel_x(0); end
    def player_pixel_y; event_pixel_y(0); end
    def player_direction; event(0).direction; end
    def distance_between(flag, ev1, ev2)
      ev1, ev2 = event(ev1), event(ev2)
      args = (ev1.screen_x-ev2.screen_x),(ev1.screen_y-ev2.screen_y)
      args = (ev1.x-ev2.x),(ev1.y-ev2.y) if flag == :square
      Math.hypot(*args).to_i
    end
    def squares_between(ev1, ev2); distance_between(:square, ev1, ev2); end
    def pixels_between(ev1, ev2); distance_between(:pixel, ev1, ev2); end
    def event_look_at?(ev, to, scope, metric = :square)
      if event_direction(ev) == 8
        x_axis = event_x(to) == event_x(ev)
        y_axis = event_y(ev) > event_y(to)
      end
      if event_direction(ev) == 2
        x_axis = event_x(to) == event_x(ev)
        y_axis = event_y(ev) < event_y(to)
      end
      if event_direction(ev) == 4
        x_axis = event_x(to) < event_x(ev)
        y_axis = event_y(ev) == event_y(to)
      end
      if event_direction(ev) == 6
        x_axis = event_x(to) > event_x(ev)
        y_axis = event_y(ev) == event_y(to)
      end
      return x_axis && y_axis && (distance_between(metric, ev, to)<=scope)
    end
    def event_collide?(ev1, ev2)
      event1 = event(ev1)
      event2 = event(ev2)
      flag = case event1.direction
      when 2; event2.x == event1.x && event2.y == event1.y+1
      when 4; event2.x == event1.x-1 && event2.y == event1.y
      when 6; event2.x == event1.x+1 && event2.y == event1.y
      when 8; event2.x == event1.x && event2.y == event1.y-1
      else; false
      end
      return flag && !event1.moving?
    end
    def event_in_screen?(id)
      ev = event(id)
      check_x = ev.screen_x > 0 && ev.screen_x < Graphics.width
      check_y = ev.screen_y > 0 && ev.screen_y < Graphics.height
      check_x && check_y
    end
    def player_in_screen?
      event_in_screen?(0)
    end

    append_commands
  end

  #==============================================================================
  # ** Skills
  #------------------------------------------------------------------------------
  #  Skills commands
  #==============================================================================

  module Skills

    def skill_name(id); $data_skills[id].name; end 
    def skill_note(id); $data_skills[id].note; end 
    def skill_description(id); $data_skills[id].description; end
    def skill_icon(id); $data_skills[id].icon_index; end
    def skill_scope(id)
      $data_skills[id].scope
    end
    def skill_has_no_scope?(id)
      skill_scope(id) == 0
    end
    def skill_for_one_enemy?(id)
      skill_scope(id) == 1
    end
    def skill_for_all_enemies?(id)
      skill_scope(id) == 2
    end
    def skill_for_one_random_enemy?(id)
      skill_scope(id) == 3
    end
    def skill_for_two_random_enemy?(id)
      skill_scope(id) == 4
    end
    def skill_for_three_random_enemy?(id)
      skill_scope(id) == 5
    end
    def skill_for_four_random_enemy?(id)
      skill_scope(id) == 6
    end
    def skill_for_one_ally?(id)
      skill_scope(id) == 7
    end
    def skill_for_all_allies?(id)
      skill_scope(id) == 8
    end
    def skill_for_one_dead_ally?(id)
      skill_scope(id) == 9
    end
    def skill_for_all_dead_allies?(id)
      skill_scope(id) == 10
    end
    def skill_for_caller?(id)
      skill_scope(id) == 11
    end
    def skill_occasion(id)
      $data_skills[id].occasion
    end
    def skill_always_usable?(id)
      skill_occasion(id) == 0
    end
    def skill_battle_usable?(id)
      skill_always_usable(id) || skill_occasion(id) == 1
    end
    def skill_menu_usable?(id)
      skill_always_usable(id) || skill_occasion(id) == 2
    end
    def skill_never_usable?(id)
      skill_occasion(id) == 3
    end
    def skill_for_oponent?(i); $data_skills[i].for_opponent?; end
    def skill_for_friend?(i); $data_skills[i].for_friend?; end 
    def skill_for_dead_friend?(i); $data_skills[i].for_dead_friend?; end 
    def skill_for_one?(i); $data_skills[i].for_one?; end 
    def skill_for_random?(i); $data_skills[i].for_random?; end 
    def skill_for_all?(i); $data_skills[i].for_all?; end 
    def skill_need_selection?(i); $data_skills[i].need_selection?; end 
    def skill_certain?(i); $data_skills[i].certain?; end 
    def skill_physical?(i); $data_skills[i].physical?; end 
    def skill_magical?(i); $data_skills[i].magical?; end 
    def skill_number_of_targets(i); $data_skills[i].number_of_targets; end 
    def skill_speed(i); $data_skills[i].speed; end 
    def skill_nb_hits(i); $data_skills[i].repeats; end 
    def skill_success_rate(i); $data_skills[i].success_rate; end
    def skill_tp_gain(i); $data_skills[i].tp_gain; end

    append_commands
  end

end