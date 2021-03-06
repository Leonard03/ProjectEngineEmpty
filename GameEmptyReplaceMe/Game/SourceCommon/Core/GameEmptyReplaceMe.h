//
// Copyright (c) 2012-2018 Jimmy Lord http://www.flatheadgames.com
//
// This software is provided 'as-is', without any express or implied warranty.  In no event will the authors be held liable for any damages arising from the use of this software.
// Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
// 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source distribution.

#ifndef __GameEmptyReplaceMe_H__
#define __GameEmptyReplaceMe_H__

class GameEmptyReplaceMe : public EngineCore
{
protected:

public:
    GameEmptyReplaceMe();
    virtual ~GameEmptyReplaceMe();

    virtual ComponentTypeManager* CreateComponentTypeManager() { return MyNew GameComponentTypeManager; }

    virtual void OneTimeInit();

    virtual float Tick(float deltaTime);
    virtual void OnSurfaceChanged(uint32 x, uint32 y, uint32 width, uint32 height);
    virtual void OnDrawFrame(unsigned int canvasid);

    virtual bool OnTouch(int action, int id, float x, float y, float pressure, float size);
    virtual bool OnButtons(GameCoreButtonActions action, GameCoreButtonIDs id);
    virtual bool OnKeys(GameCoreButtonActions action, int keycode, int unicodechar);
};

#endif //__GameEmptyReplaceMe_H__
