Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50156D43A
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jul 2022 07:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGKFQE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jul 2022 01:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:16:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989AF14030
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0el4Y0p0idmzAjcaHhkQx+ZApFhqrKCBDW9V+myNSyw=; b=qeRFeprw1HvoyQy16SO7MXpw10
        BNCGqX2ffShtjLY2ST62ktR6Qj5KIx4weVshuS0sZafO2cJT6cNiUKQOZZPcBhogDGhGwS72Mfu9Y
        i1Q/za6L1kBdznRl1qLWcauoioxgBCpHj1b3JGofqKRCQdiMaS9pk4G0w6LG6a0+MInZuyNZxO60j
        H22Gs/rYxjBzOqlkbPuyHjAd3j0ZgQidMN9Wv/+q3+Z17nflGfPaj2DxtpNNH4IGmWiNvBsqZNDzW
        qDFP8CpCQQaGL4dZV3G0peGEX0ku/OVyyEwxidZBP+WCYUJx9iJ1bmwNgccWtjanKxe1Pih5ygaFi
        LPPQu+Vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlm5-00G4ts-Fy; Mon, 11 Jul 2022 05:16:01 +0000
Date:   Sun, 10 Jul 2022 22:16:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <YsuyEeqowEgaM118@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-7-david@fromorbit.com>
 <YrzMeZ/mW+yN94Oo@magnolia>
 <20220707123633.GM227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707123633.GM227878@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 10:36:33PM +1000, Dave Chinner wrote:
> > 
> > Hmm, so what still uses pag_buf_lock?  Are we still using it to
> > serialize xfs_buf_rele calls?
> 
> slow path lookup/insert and xfs_buf_rele calls.

Note that we might be able to eventually remove the locking in rele
if we switch the lookup slow path to use atomic_inc_unless_zero as
well.  But it would need a very careful audit.
