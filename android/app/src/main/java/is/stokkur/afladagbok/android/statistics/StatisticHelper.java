/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.statistics;

import android.app.Activity;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.FishSpeciesTotalCatch;
import is.stokkur.afladagbok.android.models.MammalAndBirdsTotalCatch;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 12/19/17.
 */

public class StatisticHelper {

    public static void addLayouts(ArrayList<FishSpeciesTotalCatch> catches,
                                  ArrayList<MammalAndBirdsTotalCatch> mammalsAndBirds,
                                  double totalCatchKg,
                                  LinearLayout statisticsLayout,
                                  LinearLayout statisticsList,
                                  Activity context) {
        Resources resources = context.getResources();

        View lastView = null;
        for (int i = 0; i < catches.size(); i++) {
            FishSpeciesTotalCatch totalCatch = catches.get(i);
            LinearLayout.LayoutParams lParams =
                    new LinearLayout.LayoutParams(0,
                            LinearLayout.LayoutParams.MATCH_PARENT,
                            (float) (totalCatch.getWeight() / totalCatchKg) * 1000);
            View view = new View(context);
            view.setLayoutParams(lParams);

            int color = Color.parseColor(totalCatch.getColorCode());
            int opaqueColor = OpaqueColor(color);
            int lightenColor = LightenColor(color);
            if (catches.size() == 1) {
                view.setBackground(resources.getDrawable(R.drawable.round_corners, null));
            } else if (i == 0) {
                view.setBackground(resources.getDrawable(R.drawable.left_corners, null));
            } else if (i == 1) {
                view.setBackground(resources.getDrawable(R.drawable.right_corners, null));
                lastView = view;
            } else {
                view.setBackground(resources.getDrawable(R.drawable.no_corners, null));
            }
            GradientDrawable drawable = (GradientDrawable) view.getBackground();
            drawable.mutate();
            drawable.setColors(new int[]{lightenColor,color,opaqueColor});
            drawable.setGradientType(GradientDrawable.LINEAR_GRADIENT);
            drawable.setOrientation(GradientDrawable.Orientation.TOP_BOTTOM);
            if (i!=1) {
                statisticsLayout.addView(view);
            }
        }
        if ( lastView != null ){
            statisticsLayout.addView(lastView);
        }

        lastView = null;
        for (int i = 0; i < catches.size(); i++) {
            FishSpeciesTotalCatch totalCatch = catches.get(i);
            View catchView = context.getLayoutInflater().
                    inflate(R.layout.fish_amount_item, statisticsList, false);
            TextView fishName = catchView.findViewById(R.id.fish_name);
            TextView fishWeight = catchView.findViewById(R.id.fish_weight);
            View colorView = catchView.findViewById(R.id.color_view);
            if (totalCatch.isSmallFish()) {
                fishName.setText(context.getString(R.string.fish_small_catch,
                        totalCatch.getFishSpecies().getSpeciesName()));
            } else {
                fishName.setText(totalCatch.getFishSpecies().getSpeciesName());
            }
            fishWeight.setText(resources.getString(R.string.fish_catch_kg, totalCatch.getWeight()));
            GradientDrawable drawable = (GradientDrawable) colorView.getBackground();
            int color = Color.parseColor(totalCatch.getColorCode());
            int opaqueColor = OpaqueColor(color);
            int lightenColor = LightenColor(color);
            drawable.mutate();
            drawable.setColors(new int[]{lightenColor,color,opaqueColor});
            drawable.setGradientType(GradientDrawable.LINEAR_GRADIENT);
            drawable.setOrientation(GradientDrawable.Orientation.TOP_BOTTOM);
            if(i != 1) {
                statisticsList.addView(catchView);
            } else {
                lastView = catchView;
            }
        }
        if (lastView != null){
            statisticsList.addView(lastView);
        }

        if (mammalsAndBirds != null) {
            for (MammalAndBirdsTotalCatch totalCatch : mammalsAndBirds) {
                View catchView = context.getLayoutInflater().
                        inflate(R.layout.fish_amount_item, statisticsList, false);
                TextView fishName = catchView.findViewById(R.id.fish_name);
                TextView fishWeight = catchView.findViewById(R.id.fish_weight);
                View colorView = catchView.findViewById(R.id.color_view);

                fishName.setText(totalCatch.getOtherSpecies().getSpecieName());
                fishWeight.setText(resources.getString(R.string.mammal_and_bird_catch_count,
                        totalCatch.getCount()));
                GradientDrawable drawable = (GradientDrawable) colorView.getBackground();
                int color = Color.BLACK;
                int opaqueColor = OpaqueColor(color);
                int lightenColor = LightenColor(color);
                drawable.mutate();
                drawable.setColors(new int[]{lightenColor,color,opaqueColor});
                drawable.setGradientType(GradientDrawable.LINEAR_GRADIENT);
                drawable.setOrientation(GradientDrawable.Orientation.TOP_BOTTOM);
                statisticsList.addView(catchView);
            }
        }
    }


    private static int LightenColor(int color){
        int brightConstant = 70;

        int red = Color.red(color);
        int green = Color.green(color);
        int blue = Color.blue(color);
        int alpha = Color.alpha(color);

        int newRed = Math.min(red + brightConstant, 255);
        int newGreen = Math.min(green + brightConstant, 255);
        int newBlue = Math.min(blue + brightConstant, 255);

        return Color.argb(alpha, newRed, newGreen, newBlue);
    }

    private static int OpaqueColor(int color){
        int constant = 70;

        int red = Color.red(color);
        int green = Color.green(color);
        int blue = Color.blue(color);
        int alpha = Color.alpha(color);

        int newRed = Math.max(red - constant, 0);
        int newGreen = Math.max(green - constant, 0);
        int newBlue = Math.max(blue - constant, 0);

        return Color.argb(alpha, newRed, newGreen, newBlue);
    }

}
