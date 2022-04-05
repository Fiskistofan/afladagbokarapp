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

package is.stokkur.afladagbok.android.dialogs;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.utils.Utils;

import static is.stokkur.afladagbok.android.utils.Utils.getTossType;
import static is.stokkur.afladagbok.android.utils.Utils.getTossTypeName;

public class TossInfoDialog extends Dialog {

    public <T extends Fragment & TossInfoHandler> TossInfoDialog(final @NonNull T fragment, final StoredToss toss) {
        super(fragment.getActivity());
        Window window = getWindow();
        setContentView(R.layout.dialog_toss_info);
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        final Activity activity = fragment.getActivity();

        View.OnClickListener listener = view -> {
            dismiss();
            switch (view.getId()) {
                case R.id.toss_info_close: {
                    break;
                }
                case R.id.toss_info_action_drag: {
                    fragment.promptPullInDialog(toss);
                    break;
                }
            }
        };

        View content = findViewById(R.id.toss_info_content);
        content.findViewById(R.id.toss_info_close).
                setOnClickListener(listener);

        String tossTypeName = getTossTypeName(toss);

        ((TextView) content.findViewById(R.id.toss_info_title)).
                setText(tossTypeName);

        ((TextView) content.findViewById(R.id.toss_info_amount_label)).
                setText(activity.getString(R.string.toss_count_label, tossTypeName.toLowerCase()));

        String amount;
        String type = getTossType(toss);
        String available = String.valueOf(toss.getCount() - toss.getPulledCount());
        if (type.compareTo(FishingEquipments.HAND) == 0) {
            amount = available;
        } else {
            amount = available + "/" + toss.getCount();
        }
        ((TextView) content.findViewById(R.id.toss_info_amount)).
                setText(amount);

        ((TextView) content.findViewById(R.id.toss_info_date)).
                setText(Utils.formatToDayMonthYearHourMinutes(toss.getDateTime()));

        ((TextView) content.findViewById(R.id.toss_info_gps)).setText(activity.
                getString(R.string.toss_location, toss.getLatitude(), toss.getLongitude()));

        TextView actionDrag = content.findViewById(R.id.toss_info_action_drag);
        actionDrag.setText(activity.getString(R.string.drag_toss, tossTypeName));
        actionDrag.setOnClickListener(listener);
    }

}
