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

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.utils.Utils;

import static is.stokkur.afladagbok.android.utils.Utils.getShortNameForType;
import static is.stokkur.afladagbok.android.utils.Utils.getTossType;

/**
 * Created by annalaufey on 2/5/18.
 */

 class SelectTossDialogAdapter extends RecyclerView.Adapter<SelectTossDialogAdapter.TossDialogViewHolder> {

    private List<StoredToss> storedTossList;
    private Context context;
    private TossSelectedListener tossSelectedListener;

    public SelectTossDialogAdapter(List<StoredToss> storedTossList, Context context) {
        this.storedTossList = storedTossList;
        this.context = context;
    }

    @Override
    public TossDialogViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.toss_selection_item, parent, false);
        SelectTossDialogAdapter.TossDialogViewHolder viewHolder = new SelectTossDialogAdapter.TossDialogViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(TossDialogViewHolder holder, int position) {
        StoredToss toss = storedTossList.get(position);
        holder.tossName.setText(Utils.formatToDayMonthYearHourMinutes(toss.getDateTime()));
        holder.tossLayout.setOnClickListener(v -> tossSelectedListener.tossSelected(toss));
        String type = getTossType(toss);
        int available = toss.getCount() - toss.getPulledCount();
        if (type.compareTo(FishingEquipments.HAND) == 0) {
            holder.leftOverToss.setText(context.getResources().getString(R.string.amount_toss,
                    getShortNameForType(context, getTossType(toss)), available));
        } else {
            holder.leftOverToss.setText(context.getResources().getString(R.string.amount_toss_out_of,
                    getShortNameForType(context, getTossType(toss)), available, toss.getCount()));
        }
    }

    @Override
    public int getItemCount() {
        return storedTossList.size();
    }

    public void setTossSelectedListener(TossSelectedListener tossSelectedListener) {
        this.tossSelectedListener = tossSelectedListener;
    }

    public class TossDialogViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.toss_name)
        TextView tossName;
        @BindView(R.id.toss_layout)
        RelativeLayout tossLayout;
        @BindView(R.id.toss_left)
        TextView leftOverToss;

        public TossDialogViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);

        }
    }

}
