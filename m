Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E197CE2BE
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Oct 2023 18:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjJRQ1x (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Oct 2023 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjJRQ1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 12:27:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E51AB
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 09:27:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CEFC433C8;
        Wed, 18 Oct 2023 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697646470;
        bh=b+u5iiJAgUrPPPnSeAEnPsAg03hBiTILwBNSAKyq3YQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vg1sDaODg7I1eri6hvvWEdc00WUZMYfZZN2vowSNqiIYqOqr5yV9tleWemjlhlkNd
         sfkbnjsXcjoKQ8qi2pl6Oiar3/s561ESszRJbW90NkcGB6X7z7X7nEqhFBMRwreMIC
         nW+B3WeTRsTxedmo7dSnBKi1133EnaEOa261I+ClXoJlUfj+WYKK4pZ5uEcn4x1/vk
         r/cnQ8CR/sosm/CwO8An9qSqVIVH65zXWKMj9RqoPTivBWxjM/6CbxpkYph+6vKPr6
         hRei2Q8qJEvyCreRu+8qnM8WTvBqzBhOIVn/UZPlKzpbhcZcn5WW0fbgma8r2U3uea
         uFEjlelBNFScw==
Date:   Wed, 18 Oct 2023 09:27:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: use accessor functions for bitmap words
Message-ID: <20231018162749.GG3195650@frogsfrogsfrogs>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs>
 <169759503104.3396240.5905890094753315092.stgit@frogsfrogsfrogs>
 <20231018045425.GD15759@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018045425.GD15759@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 06:54:25AM +0200, Christoph Hellwig wrote:
> > +/* Convert an ondisk bitmap word to its incore representation. */
> > +static inline xfs_rtword_t
> > +xfs_rtbitmap_getword(
> > +	struct xfs_buf		*bp,
> > +	unsigned int		index)
> > +{
> > +	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
> > +
> > +	return word->old;
> > +}
> > +
> > +/* Set an ondisk bitmap word from an incore representation. */
> > +static inline void
> > +xfs_rtbitmap_setword(
> > +	struct xfs_buf		*bp,
> > +	unsigned int		index,
> > +	xfs_rtword_t		value)
> > +{
> > +	union xfs_rtword_raw	*word = xfs_rbmblock_wordptr(bp, index);
> > +
> > +	word->old = value;
> > +}
> 
> Before getting rid of xfs_rbmblock_wordptr I initially did this as:
> 
> 	return xfs_rbmblock_wordptr(bp, index)->old;
> 
> and
> 	xfs_rbmblock_wordptr(bp, index)->old = value;
> 
> which looks a little neater to me.

I set up the function in that (for now) verbose manner to reduce the
diff when the rtgroups patchset redefines the ondisk format to include a
block header (and crcs) and enforces endiannness:

/* Convert an ondisk bitmap word to its incore representation. */
static inline xfs_rtword_t
xfs_rtbitmap_getword(
        struct xfs_buf          *bp,
        unsigned int            index)
{
        union xfs_rtword_raw    *word = xfs_rbmblock_wordptr(bp, index);

        if (xfs_has_rtgroups(bp->b_mount))
                return le32_to_cpu(word->rtg);
        return word->old;
}

So I hope you don't mind if I leave it the way it is now. :)

--D

> Otherwise looks good:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
