Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FE37CD38C
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Oct 2023 07:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJRFbb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Oct 2023 01:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjJRFba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 01:31:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E0BB0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 22:31:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E008C433C8;
        Wed, 18 Oct 2023 05:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697607088;
        bh=09pltqyraHEnwIVGQ/0bJoqJzCMDNOcM3VD84zJMAt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DFyjLpFkTbJ5+n6HPciK2i6I89uC1skHRn5/qhj7obIOVzJc8Jxh6Bbn/8+FveD5d
         Wb2jZMVNB6kQ97ZfR2e0XdafdrpusiTVibnFpuwzyJyR91LLxhk3kcfsXgGACYtxPH
         vQ/DnLG6XFB+2MHARtddVy/H4S2BDu0goY0ViBEQZnax1bhePmPQcHf40CDssP8U8W
         4/LPc1MlpomKoGYRh1YLdKCl3ZA/Y8IMexz1wOpGisevNTYg1xhgh4bRaZG8yLCzC8
         JCJFkhzOEmvOGjvop8+PwwgIM2LHi4iugRun9K144Z0l0G21wIeL6wkdt/a/SHNuLh
         ulhHyMw4XSaZQ==
Date:   Tue, 17 Oct 2023 22:31:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: use accessor functions for summary info words
Message-ID: <20231018053127.GE3195650@frogsfrogsfrogs>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs>
 <169759504247.3396240.12544584850393209864.stgit@frogsfrogsfrogs>
 <20231018051934.GF15759@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018051934.GF15759@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 07:19:34AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 17, 2023 at 07:10:42PM -0700, Darrick J. Wong wrote:
> > +static inline union xfs_suminfo_raw *
> >  xfs_rsumblock_infoptr(
> >  	struct xfs_buf		*bp,
> >  	unsigned int		index)
> >  {
> > -	xfs_suminfo_t		*info = bp->b_addr;
> > +	union xfs_suminfo_raw	*info = bp->b_addr;
> >  
> >  	return info + index;
> >  }
> >  
> > +/* Get the current value of a summary counter. */
> > +static inline xfs_suminfo_t
> > +xfs_suminfo_get(
> > +	struct xfs_buf		*bp,
> > +	unsigned int		index)
> > +{
> > +	union xfs_suminfo_raw	*info = xfs_rsumblock_infoptr(bp, index);
> > +
> > +	return info->old;
> > +}
> 
> Same nitpick as for the bitmap version.
> 
> Otherwise this looks good:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Assuming you also meant "Reviewed-by" here too? :)

> ... to actually understand the mess in xfs_rtmodify_summary_int I had
> to do the (untested) refactoring below.  I'll probably resubmit it after
> the whole series which touches a lot of this:

I'll take a look tomorrow, but yeah, xfs_rtmodify_summary_int is
confusing.

Annoyingly, I think there's a bug in new logging helpers, because all
the shutdown tests are falling all over themselves:

https://djwong.org/fstests/output/.c6b00f80b1e68bd5a3b17a7f7fbe97bab28dab740d7acf9e3fa879c3ae0c56c0/.02425ea8cdb6100e408b20dceac80a46f53f6fa1587fb4af7fba2810f2b8d0fd/?C=M;O=A

Will look at /that/ first thing...

--D

> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 2118c6f177a135..7b09caa747a720 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -433,78 +433,69 @@ xfs_trans_log_rtsummary(
>   * Summary information is returned in *sum if specified.
>   * If no delta is specified, returns summary only.
>   */
> -int
> -xfs_rtmodify_summary_int(
> +static int
> +xfs_rtmodify_summary_find(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	xfs_trans_t	*tp,		/* transaction pointer */
>  	int		log,		/* log2 of extent size */
>  	xfs_fileoff_t	bbno,		/* bitmap block number */
> -	int		delta,		/* change to make to summary info */
>  	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
>  	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
> -	xfs_suminfo_t	*sum)		/* out: summary info for this block */
> +	unsigned int	*word)
>  {
>  	struct xfs_buf	*bp;		/* buffer for the summary block */
>  	int		error;		/* error value */
> -	xfs_fileoff_t	sb;		/* summary fsblock */
>  	xfs_rtsumoff_t	so;		/* index into the summary file */
> +	xfs_fileoff_t	sb;		/* summary fsblock */
>  
>  	/*
>  	 * Compute entry number in the summary file.
>  	 */
>  	so = xfs_rtsumoffs(mp, log, bbno);
> +
>  	/*
>  	 * Compute the block number in the summary file.
>  	 */
>  	sb = xfs_rtsumoffs_to_block(mp, so);
> +
> +	/*
> +	 * Compute the word index into the summary.
> +	 */
> +	*word = xfs_rtsumoffs_to_infoword(mp, so);
> +
>  	/*
>  	 * If we have an old buffer, and the block number matches, use that.
>  	 */
>  	if (*rbpp && *rsb == sb)
> -		bp = *rbpp;
> +		return 0;
> +
>  	/*
> -	 * Otherwise we have to get the buffer.
> +	 * Otherwise we have to get a new buffer.
> +	 * If there was an old one, get rid of it first.
>  	 */
> -	else {
> -		/*
> -		 * If there was an old one, get rid of it first.
> -		 */
> -		if (*rbpp)
> -			xfs_trans_brelse(tp, *rbpp);
> -		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
> -		if (error) {
> -			return error;
> -		}
> -		/*
> -		 * Remember this buffer and block for the next call.
> -		 */
> -		*rbpp = bp;
> -		*rsb = sb;
> -	}
> +	if (*rbpp)
> +		xfs_trans_brelse(tp, *rbpp);
> +	error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
> +	if (error)
> +		return error;
> +
>  	/*
> -	 * Point to the summary information, modify/log it, and/or copy it out.
> +	 * Remember this buffer and block for the next call.
>  	 */
> -	if (delta) {
> -		unsigned int	infoword = xfs_rtsumoffs_to_infoword(mp, so);
> -		xfs_suminfo_t	val = xfs_suminfo_add(bp, infoword, delta);
> -
> -		if (mp->m_rsum_cache) {
> -			if (val == 0 && log == mp->m_rsum_cache[bbno])
> -				mp->m_rsum_cache[bbno]++;
> -			if (val != 0 && log < mp->m_rsum_cache[bbno])
> -				mp->m_rsum_cache[bbno] = log;
> -		}
> -		xfs_trans_log_rtsummary(tp, bp, infoword);
> -		if (sum)
> -			*sum = val;
> -	} else if (sum) {
> -		unsigned int	infoword = xfs_rtsumoffs_to_infoword(mp, so);
> -
> -		*sum = xfs_suminfo_get(bp, infoword);
> -	}
> +	*rbpp = bp;
> +	*rsb = sb;
>  	return 0;
>  }
>  
> +/*
> + * Read and/or modify the summary information for a given extent size,
> + * bitmap block combination.
> + * Keeps track of a current summary block, so we don't keep reading
> + * it from the buffer cache.
> + *
> + * Summary information is returned in *sum if specified.
> + * If no delta is specified, returns summary only.
> + */
>  int
>  xfs_rtmodify_summary(
>  	xfs_mount_t	*mp,		/* file system mount structure */
> @@ -515,8 +506,51 @@ xfs_rtmodify_summary(
>  	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
>  	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
>  {
> -	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
> -					delta, rbpp, rsb, NULL);
> +	int		error;
> +	unsigned int	word;
> +	xfs_suminfo_t	val;
> +
> +	error = xfs_rtmodify_summary_find(mp, tp, log, bbno, rbpp, rsb, &word);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Modify and log the summary information.
> +	 */
> +	val = xfs_suminfo_add(*rbpp, word, delta);
> +	if (mp->m_rsum_cache) {
> +		if (val == 0 && log == mp->m_rsum_cache[bbno])
> +			mp->m_rsum_cache[bbno]++;
> +		if (val != 0 && log < mp->m_rsum_cache[bbno])
> +			mp->m_rsum_cache[bbno] = log;
> +	}
> +	xfs_trans_log_rtsummary(tp, *rbpp, word);
> +	return 0;
> +}
> +
> +/*
> + * Read and return the summary information for a given extent size,
> + * bitmap block combination.
> + * Keeps track of a current summary block, so we don't keep reading
> + * it from the buffer cache.
> + */
> +int
> +xfs_rtget_summary(
> +	xfs_mount_t	*mp,		/* file system mount structure */
> +	xfs_trans_t	*tp,		/* transaction pointer */
> +	int		log,		/* log2 of extent size */
> +	xfs_fileoff_t	bbno,		/* bitmap block number */
> +	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> +	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
> +	xfs_suminfo_t	*sum)		/* out: summary info for this block */
> +{
> +	int		error;
> +	unsigned int	word;
> +
> +	error = xfs_rtmodify_summary_find(mp, tp, log, bbno, rbpp, rsb, &word);
> +	if (!error)
> +		*sum = xfs_suminfo_get(*rbpp, word);
> +	return error;
>  }
>  
>  /* Log rtbitmap block from the word @from to the byte before @next. */
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index fdfa98e0ee52f7..6d23a77def50dd 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -294,13 +294,12 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
>  		    xfs_rtxnum_t *rtblock);
>  int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		       xfs_rtxnum_t start, xfs_rtxlen_t len, int val);
> -int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
> -			     int log, xfs_fileoff_t bbno, int delta,
> -			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
> -			     xfs_suminfo_t *sum);
>  int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
>  			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
>  			 xfs_fileoff_t *rsb);
> +int xfs_rtget_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
> +		      xfs_fileoff_t bbno, struct xfs_buf **rbpp,
> +		      xfs_fileoff_t *rsb, xfs_suminfo_t *sum);
>  int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		     xfs_rtxnum_t start, xfs_rtxlen_t len,
>  		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 3be6bda2fd920c..22bc8b3b724a5b 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -21,25 +21,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_rtbitmap.h"
>  
> -/*
> - * Read and return the summary information for a given extent size,
> - * bitmap block combination.
> - * Keeps track of a current summary block, so we don't keep reading
> - * it from the buffer cache.
> - */
> -static int
> -xfs_rtget_summary(
> -	xfs_mount_t	*mp,		/* file system mount structure */
> -	xfs_trans_t	*tp,		/* transaction pointer */
> -	int		log,		/* log2 of extent size */
> -	xfs_fileoff_t	bbno,		/* bitmap block number */
> -	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
> -	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
> -	xfs_suminfo_t	*sum)		/* out: summary info for this block */
> -{
> -	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
> -}
> -
>  /*
>   * Return whether there are any free extents in the size range given
>   * by low and high, for the bitmap block bbno.
