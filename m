Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7195210E5
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 11:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiEJJde (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 05:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbiEJJdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:33:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EAF28C9E3
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LsaIIxKxUCyoxprtgkOQXSP4B3XvvlqBwTaONkppYbU=; b=Iu/Nuz6/cgh85yNU5n21WJDsWr
        fzYffhsf/JL2ZQCSi1RZ1uarykcJMAmIxHXLT5vP8Hil8THut0SXtaPnwH64soLLxHsDZpEt7mGdy
        MGv881c04AgvsibK+fWAaOIBMxNUh5nTW94NcxNRWq8mQm7/NEZuKQuE3Zm1My5KKxcayf+ID1169
        heJ05OP0j8bB8wrADqtKg7rLJr1EWAQvuSN/VdHNtcVpTi2CDXLhG3/iY0bGOtjKTtu6ENUhtJeDh
        rNsbsLRgWeOCprXK8nYtxTQBu66j5lgEeL4UqX0ddGD+w/PaYg+vaZdvxP8WtTXaDSobOuXF1XtI1
        gzK9SLTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMBT-000peP-Da; Tue, 10 May 2022 09:29:35 +0000
Date:   Tue, 10 May 2022 02:29:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <Ynowf/rmU2UVPlqw@infradead.org>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509182043.GW27195@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 11:20:43AM -0700, Darrick J. Wong wrote:
> > Is there any a priori NACK or exceptional challenges w.r.t implementing
> > upgrade of xfs to reflink support?
> 
> No, just lack of immediate user demand + time to develop and merge code
> + time to QA the whole mess to make sure it doesn't introduce any
> messes.

I also have vague memory I did an in-kernel online upgrade back in the
day but we decided to not bother in the end.  Maybe some list archive
search could find it.
