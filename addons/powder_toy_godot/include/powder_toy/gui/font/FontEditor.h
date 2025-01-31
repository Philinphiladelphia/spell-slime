#pragma once
#include <vector>
#include <array>
#include <map>

#include "graphics/FontReader.h"
#include "gui/interface/Window.h"

namespace ui
{
	class Textbox;
	class Label;
	class Button;
}

constexpr int MAX_WIDTH = 64;
class FontEditor: public ui::Window
{
	void HandleExit();

private:
	ByteString dataFile;
	std::map<PTString::value_type, unsigned char> fontWidths;
	std::map<PTString::value_type, std::array<std::array<char, MAX_WIDTH>, FONT_H> > fontPixels;

	std::vector<unsigned char> fontData;
	std::vector<unsigned int> fontPtrs;
	std::vector<std::array<unsigned int, 2> > fontRanges;

	ByteString beforeFontData;
	ByteString afterFontData;
	ByteString afterFontPtrs;
	ByteString afterFontRanges;

	void ReadDataFile(ByteString dataFile);
	void WriteDataFile(ByteString dataFile, std::vector<unsigned char> const &fontData, std::vector<unsigned int> const &fontPtrs, std::vector<std::array<unsigned int, 2> > const &fontRanges);
	static void PackData(
			std::map<PTString::value_type, unsigned char> const &fontWidths,
			std::map<PTString::value_type, std::array<std::array<char, MAX_WIDTH>, FONT_H> > const &fontPixels,
			std::vector<unsigned char> &fontData,
			std::vector<unsigned int> &fontPtrs,
			std::vector<std::array<unsigned int, 2> > &fontRanges);
	static void UnpackData(
			std::map<PTString::value_type, unsigned char> &fontWidths,
			std::map<PTString::value_type, std::array<std::array<char, MAX_WIDTH>, FONT_H> > &fontPixels,
			std::vector<unsigned char> const &fontData,
			std::vector<unsigned int> const &fontPtrs,
			std::vector<std::array<unsigned int, 2> > const &fontRanges);

	ui::Textbox *currentCharTextbox;
	ui::Button *savedButton;

	PTString::value_type currentChar;
	int fgR, fgG, fgB;
	int bgR, bgG, bgB;

	int grid;
	int rulers;

	unsigned char clipboardWidth;
	std::array<std::array<char, MAX_WIDTH>, FONT_H> clipboardPixels;

	void UpdateCharNumber();
	void PrevChar();
	void NextChar();
	void ShrinkChar();
	void GrowChar();
	void Render();
	void Save();
	void Translate(std::array<std::array<char, MAX_WIDTH>, FONT_H> &, int dx, int dy);

public:
	FontEditor(ByteString dataFile);
	FontEditor(ByteString target, ByteString source); /* Merge mode */

	void OnDraw() override;
	void OnMouseDown(int x, int y, unsigned button) override;
	void OnKeyPress(int key, int scan, bool repeat, bool shift, bool ctrl, bool alt) override;
};
