Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B9F7362ED
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jun 2023 07:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjFTFBI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Jun 2023 01:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjFTFBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 01:01:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D593AE2;
        Mon, 19 Jun 2023 22:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0BC60F38;
        Tue, 20 Jun 2023 05:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6576C433C0;
        Tue, 20 Jun 2023 05:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687237262;
        bh=urd3HvefVd1J/0znLoAuYLfUncRuPzZZrK6PjZZeph8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JfjP4CviArg0KjbmoEw/GLjX/3DKDOuOSQbN8IS4ylMW+DrX540vayX19Nip2X//D
         UJWsM8wmvkfYgGKdtQ3SQOkAnz2vXhLvF0mMg607ycWYNC9yfPrx6k2eT0vQ26QS+v
         FS6FL3roJzx1DVsM6OFmwkT+CSMWOHegB8idNfG2kd9iRKfJ0o/bZnznAq9tdjHtlN
         9LQ40h8lsFmpVr192fvUyjVGH5grWeRUqTEe5Lyy/dsqYfYfYknY4K4LaAhvqSOaMM
         xdxeavDmWZmmHyBo/y1CbZK53w2ICyvkepNrpTQfLmKyOR5zW5tNDuDQdnEZ4zgquh
         Jxyp1qWdrGQtQ==
Date:   Mon, 19 Jun 2023 22:01:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [PATCHv10 8/8] iomap: Add per-block dirty state tracking to
 improve performance
Message-ID: <20230620050102.GF11467@frogsfrogsfrogs>
References: <ZJCINLpHGifRHewa@casper.infradead.org>
 <87ilbjmkd6.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilbjmkd6.fsf@doe.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 19, 2023 at 10:59:09PM +0530, Ritesh Harjani wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
> > On Mon, Jun 19, 2023 at 09:55:53PM +0530, Ritesh Harjani wrote:
> >> Matthew Wilcox <willy@infradead.org> writes:
> >> 
> >> > On Mon, Jun 19, 2023 at 07:58:51AM +0530, Ritesh Harjani (IBM) wrote:
> >> >> +static void ifs_calc_range(struct folio *folio, size_t off, size_t len,
> >> >> +		enum iomap_block_state state, unsigned int *first_blkp,
> >> >> +		unsigned int *nr_blksp)
> >> >> +{
> >> >> +	struct inode *inode = folio->mapping->host;
> >> >> +	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> >> >> +	unsigned int first = off >> inode->i_blkbits;
> >> >> +	unsigned int last = (off + len - 1) >> inode->i_blkbits;
> >> >> +
> >> >> +	*first_blkp = first + (state * blks_per_folio);
> >> >> +	*nr_blksp = last - first + 1;
> >> >> +}
> >> >
> >> > As I said, this is not 'first_blkp'.  It's first_bitp.  I think this
> >> > misunderstanding is related to Andreas' complaint, but it's not quite
> >> > the same.
> >> >
> >> 
> >> We represent each FS block as a bit in the bitmap. So first_blkp or
> >> first_bitp or first_blkbitp essentially means the same. 
> >> I went with first_blk, first_blkp in the first place based on your
> >> suggestion itself [1].
> >
> > No, it's not the same!  If you have 1kB blocks in a 64kB page, they're
> > numbered 0-63.  If you 'calc_range' for any of the dirty bits, you get
> > back a number in the range 64-127.  That's not a block number!  It's
> > the number of the bit you want to refer to.  Calling it blkp is going
> > to lead to confusion -- as you yourself seem to be confused.
> >
> >> [1]: https://lore.kernel.org/linux-xfs/Y%2FvxlVUJ31PZYaRa@casper.infradead.org/
> >
> > Those _were_ block numbers!  off >> inode->i_blkbits calculates a block
> > number.  (off >> inode->i_blkbits) + blocks_per_folio() does not calculate
> > a block number, it calculates a bit number.
> >
> 
> Yes, I don't mind changing it to _bit. It is derived out of an FS block
> representation only. But I agree with your above argument using _bit in
> variable name makes it explicit and clear.
> 
> >> >> -	return bitmap_full(ifs->state, i_blocks_per_folio(inode, folio));
> >> >> +	return bitmap_full(ifs->state, nr_blks);
> >> >
> >> > I think we have a gap in our bitmap APIs.  We don't have a
> >> > 'bitmap_range_full(src, pos, nbits)'.  We could use find_next_zero_bit(),
> >> > but that's going to do more work than necessary.
> >> >
> >> > Given this lack, perhaps it's time to say that you're making all of
> >> > this too hard by using an enum, and pretending that we can switch the
> >> > positions of 'uptodate' and 'dirty' in the bitmap just by changing
> >> > the enum.
> >> 
> >> Actually I never wanted to use the the enum this way. That's why I was
> >> not fond of the idea behind using enum in all the bitmap state
> >> manipulation APIs (test/set/).
> >> 
> >> It was only intended to be passed as a state argument to ifs_calc_range()
> >> function to keep all the first_blkp and nr_blksp calculation at one
> >> place. And just use it's IOMAP_ST_MAX value while allocating state bitmap.
> >> It was never intended to be used like this.
> >> 
> >> We can even now go back to this original idea and keep the use of the
> >> enum limited to what I just mentioned above i.e. for ifs_calc_range().
> >> 
> >> And maybe just use this in ifs_alloc()?
> >> BUILD_BUG_ON(IOMAP_ST_UPTODATE == 0);
> >> BUILD_BUG_ON(IOMAP_ST_DIRTY == 1);
> >> 
> >> > Define the uptodate bits to be the first ones in the bitmap,
> >> > document it (and why), and leave it at that.
> >> 
> >> Do you think we can go with above suggestion, or do you still think we
> >> need to drop it?
> >> 
> >> In case if we drop it, then should we open code the calculations for
> >> first_blk, last_blk? These calculations are done in exact same fashion
> >> at 3 places ifs_set_range_uptodate(), ifs_clear_range_dirty() and
> >> ifs_set_range_dirty().
> >> Thoughts?
> >
> > I disliked the enum from the moment I saw it, but didn't care enough to
> > say so.
> >
> > Look, an abstraction should have a _purpose_.  The enum doesn't.  I'd
> > ditch this calc_range function entirely; it's just not worth it.
> 
> I guess enum is creating more confusion with almost everyone than adding value.
> So I don't mind ditching it (unless anyone else opposes for keeping it).
> 
> Also it would be helpful if you could let me know of any other review
> comments on the rest of the patch? Does the rest looks good to you?

I deleted my entire angry rant about how this review has turned a
fairly simple design change into a big mess that even the reviewers
don't understand anymore.  I'm on vacation, I DGAF anymore.

Ritesh: Dump the enum; "because btrfs does it" is not sufficient
justification.  The rest is good enough, I'll put it in iomap-for-next
along with willy's thing as soon as 6.5-rc1 closes, and if you all have
further complaints, send your own patches.

--D

> -ritesh
