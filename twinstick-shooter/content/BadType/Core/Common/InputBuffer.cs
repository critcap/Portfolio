using Godot;
using System;
using System.Collections.Generic;
using System.Net;

/// <summary>
/// Keeps track of recent inputs in order to make timing windows more flexible.
/// Intended use: Add this file to your project as an AutoLoad script and have other objects call the class' static 
/// methods.
/// (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
/// </summary>
public partial class InputBuffer : Node
{
    /// <summary>
    /// How many milliseconds ahead of time the player can make an input and have it still be recognized.
    /// I chose the value 150 because it imitates the 9-frame buffer window in the Super Smash Bros. Ultimate game.
    /// </summary>
    private static ulong BUFFER_WINDOW = 150;

    /// <summary> Tells when each keyboard key was last pressed. </summary>
    private static Dictionary<uint, ulong> _keyboardTimestamps;
    /// <summary> Tells when each joypad (controller) button was last pressed. </summary>
    private static Dictionary<int, ulong> _joypadTimestamps;

    /// <summary>
    /// Called when the node enters the scene tree for the first time.
    /// </summary>
    public override void _Ready()
    {
        ProcessMode = ProcessModeEnum.Always;
        BUFFER_WINDOW = 140;
        // Initialize all dictionary entries.
        _keyboardTimestamps = new Dictionary<uint, ulong>();
        _joypadTimestamps = new Dictionary<int, ulong>();
    }

    /// <summary>
    /// Called whenever the player makes an input.
    /// </summary>
    /// <param name="@event"> Object containing information about the input. </param>
    public override void _Input(InputEvent @event)
    {
        // Get a numerical representation of the input and store it in the timestamp dictionary.
        if (@event is InputEventKey)
        {
            InputEventKey eventKey = @event as InputEventKey;
            if (eventKey.IsEcho()) return;
            uint scancode = (uint) eventKey.Keycode;
            if (!eventKey.Pressed)
            {
                if (!_keyboardTimestamps.ContainsKey(scancode)) return;
                _keyboardTimestamps[scancode] = 0;
                return;
            }

            if (_keyboardTimestamps.ContainsKey(scancode))
            {
                // The Time.GetTicksMsec() value will wrap after roughly 500 million years. TODO: Implement a very slow 
                // memory leak so the game crashes before that happens.
                _keyboardTimestamps[scancode] = Time.GetTicksMsec();
            }
            else
            {
                _keyboardTimestamps.Add(scancode, Time.GetTicksMsec());
            }
        }
        else if (@event is InputEventJoypadButton)
        {
            InputEventJoypadButton eventJoypadButton = @event as InputEventJoypadButton;
            if (!eventJoypadButton.Pressed || eventJoypadButton.IsEcho()) return;

            int buttonIndex = (int) eventJoypadButton.ButtonIndex;

            if (_joypadTimestamps.ContainsKey(buttonIndex))
            {
                _joypadTimestamps[buttonIndex] = Time.GetTicksMsec();
            }
            else
            {
                _joypadTimestamps.Add(buttonIndex, Time.GetTicksMsec());
            }
        }
    }

    /// <summary>
    /// Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer 
    /// window.
    /// </summary>
    /// <param name="action"> The action to check for in the buffer. </param>
    /// <returns>
    /// True if any of the action's associated keys/buttons were pressed within the buffer window, false otherwise. 
    /// </returns>
    public static bool IsActionPressBuffered(string action, ulong window = 0)
    {
        /*
        Get the inputs associated with the action. If any one of them was pressed in the last BUFFER_WINDOW 
        milliseconds, the action is buffered.
        */
        window = window == 0 ? BUFFER_WINDOW : window;
        foreach (InputEvent @event in InputMap.ActionGetEvents(action))
        {
            if (@event is InputEventKey)
            {
                InputEventKey eventKey = @event as InputEventKey;
                uint scancode = (uint) eventKey.Keycode;
                if (_keyboardTimestamps.ContainsKey(scancode))
                {
                    if (Time.GetTicksMsec() - _keyboardTimestamps[scancode] <= window)
                    {
                        // Prevent this method from returning true repeatedly and registering duplicate actions.
                        InvalidateAction(action);

                        return true;
                    }
                }
            }
            else if (@event is InputEventJoypadButton)
            {
                InputEventJoypadButton eventJoypadButton = @event as InputEventJoypadButton;
                int buttonIndex = (int) eventJoypadButton.ButtonIndex;
                if (_joypadTimestamps.ContainsKey(buttonIndex))
                {
                    if (Time.GetTicksMsec() - _joypadTimestamps[buttonIndex] <= BUFFER_WINDOW)
                    {
                        InvalidateAction(action);
                        return true;
                    }
                }
            }
        }
        /* 
        If there's ever a third type of buffer-able action (mouse clicks maybe?), it'd probably be worth it to 
        generalize the repetitive keyboard/joypad code into something that works for any input method. Until then, by 
        the YAGNI principle, the repetitive stuff stays >:)
        */

        return false;
    }

    public static bool IsActionHold(string action)
    {
        if (!InputMap.HasAction(action)) return false;
        var events = InputMap.ActionGetEvents(action);
        foreach (InputEvent @event in events) 
        {
            if (@event is not InputEventKey eventKey) continue;
            uint scancode = (uint) eventKey.Keycode; 
            if (!_keyboardTimestamps.ContainsKey(scancode)) continue;
            if (_keyboardTimestamps[scancode] == 0) return false;
            var timme = Time.GetTicksMsec();
            var delta = timme - _keyboardTimestamps[scancode]; 
            return delta > BUFFER_WINDOW;
        }

        return false;
    }


    /// <summary>
    /// Records unreasonable timestamps for all the inputs in an action. Called when IsActionPressBuffered returns true,
    /// as otherwise it would continue returning true every frame for the rest of the buffer window.
    /// </summary>
    /// <param name="action"> The action whose input to invalidate. </param>
    public static void InvalidateAction(string action)
    {
        foreach (InputEvent @event in InputMap.ActionGetEvents(action))
        {
            if (@event is InputEventKey)
            {
                InputEventKey eventKey = @event as InputEventKey;
                uint scancode = (uint) eventKey.Keycode;
                if (_keyboardTimestamps.ContainsKey(scancode))
                {
                    _keyboardTimestamps[scancode] = 0;
                }
            }
            else if (@event is InputEventJoypadButton)
            {
                InputEventJoypadButton eventJoypadButton = @event as InputEventJoypadButton;
                int buttonIndex = (int) eventJoypadButton.ButtonIndex;
                if (_joypadTimestamps.ContainsKey(buttonIndex))
                {
                    _joypadTimestamps[buttonIndex] = 0;
                }
            }
        }
    }

    private uint GetScancode(InputEventKey keyEvent)
    {
       return (uint) keyEvent.Keycode;
    }
}