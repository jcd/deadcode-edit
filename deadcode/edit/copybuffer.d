module deadcode.edit.copybuffer;

import deadcode.test;

import std.conv;
import std.range;

interface IClipboard
{    
    @property
    {
        bool hasText() const;
        string text() const;
        void text(string t);
    }
}

version (unittest)
{
    class MockClipboard : IClipboard
    {
        @property
        {
            bool hasText() const { return false; }
            string text() const { assert(0); }
            void text(string t) { assert(0); }
        }
    }
}

class CopyBuffer
{
    private IClipboard _clipboard;

	static class Entry
	{
		this(string t)
		{
			txt = t;
		}
		string txt;
	}
	Entry[] entries;

    this(IClipboard c)
    {
    
    }

	@property bool empty() const
	{
        return entries.empty && !_clipboard.hasText;	
    }

	@property size_t length() const
	{
        if (_clipboard.hasText)
		{
			if (entries.empty)
			{
				return 1;
			}
		    else if (entries[$-1].txt == _clipboard.text)
			{
				return entries.length;
			}
			else
			{
				return entries.length + 1;
			}
		}
		else
		{
			return entries.length;
		}
	}

	void add(string t)
	{
		import std.string;
		entries ~= new Entry(t);
        _clipboard.text = t;
	}

	Entry get(int offset)
	{
		auto len =  length;
		if (offset >= len)
			return null;

        if (_clipboard.hasText)
		{
			if (entries.empty)
			{
				return new Entry(_clipboard.text);
			}
			else if (entries[$-1].txt == _clipboard.text)
			{
				return entries[$-offset-1];
			}
			else if (offset == 0)
			{
				return new Entry(_clipboard.text);
			}
			else
			{
				return entries[$-offset];
			}
		}
		else
		{
			return entries[$-offset-1];
		}
	}
}
