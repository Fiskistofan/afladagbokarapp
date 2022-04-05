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

package is.stokkur.afladagbok.android.book;

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
import is.stokkur.afladagbok.android.models.Species;
import is.stokkur.afladagbok.android.utils.SpeciesID;

/**
 * Created by annalaufey on 11/16/17.
 */

public class SpeciesAdapter extends RecyclerView.Adapter<SpeciesAdapter.SpeciesViewHolder> {

    private List<Species> species;
    private Context context;
    private NextFragmentListener nextFragmentListener;

    public SpeciesAdapter(List<Species> species, Context context) {
        this.species = species;
        this.context = context;
    }

    @Override
    public SpeciesViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.species_item, parent, false);
        SpeciesViewHolder viewHolder = new SpeciesViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(SpeciesViewHolder holder, int position) {
        holder.speciesName.setText(species.get(position).getSpeciesName());
        switch (species.get(position).getId()) {
            case SpeciesID.FISH:
                holder.speciesImage.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_fish, null));
                break;
            case SpeciesID.OTHER:
                holder.speciesImageExtra.setVisibility(View.VISIBLE);
                holder.speciesImageExtra.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_bird,null));
                holder.speciesImage.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_mamal_new, null));
                break;
        }
        holder.speciesCardView.setOnClickListener(v -> nextFragmentListener.goToNextFragment(species.get(position).getId()));
    }

    @Override
    public int getItemCount() {
        return species.size();
    }

    public void setNextFragmentListener(NextFragmentListener nextFragmentListener) {
        this.nextFragmentListener = nextFragmentListener;
    }

    public class SpeciesViewHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.species_name)
        TextView speciesName;
        @BindView(R.id.species_image_extra)
        ImageView speciesImageExtra;
        @BindView(R.id.species_image)
        ImageView speciesImage;
        @BindView(R.id.species_card_view)
        LinearLayout speciesCardView;

        public SpeciesViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}
