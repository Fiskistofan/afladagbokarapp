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

package is.stokkur.afladagbok.android.boats;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.Ship;
import is.stokkur.afladagbok.android.utils.Persistence;

/**
 * Created by annalaufey on 1/11/18.
 */

public class BoatsAdapter extends RecyclerView.Adapter<BoatsAdapter.BoatsViewHolder> {


    private List<Ship> boats;
    private Context context;


    public BoatsAdapter(List<Ship> boats, Context context) {
        this.boats = boats;
        this.context = context;
    }

    @Override
    public BoatsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.boat_item, parent, false);
        BoatsViewHolder viewHolder = new BoatsViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(BoatsViewHolder holder, int position) {

        holder.boatItem.setOnClickListener(v -> {
            Persistence.saveStringValue(Persistence.KEY_CURRENT_BOAT_ID, String.valueOf(boats.get(position).getId()));
            notifyDataSetChanged();
        });

        String currentBoatId = Persistence.getStringValue(Persistence.KEY_CURRENT_BOAT_ID);

        if (String.valueOf(boats.get(position).getId()).compareTo(currentBoatId) == 0) {
            holder.selectBoatIcon.setVisibility(View.VISIBLE);
        }

        holder.boatName.setText(boats.get(position).getName());
    }

    @Override
    public int getItemCount() {
        return boats.size();
    }

    public class BoatsViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.boat_item)
        LinearLayout boatItem;
        @BindView(R.id.boat_name)
        TextView boatName;
        @BindView(R.id.selected_boat_image)
        ImageView selectBoatIcon;

        public BoatsViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}
