Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F0C55F861
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 09:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiF2HG7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 03:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiF2HGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:06:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED2632E
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iiUp6+87gjd3DrItlyCzA2H9VwVJvqYk3jH2qaHKScU=; b=PqGx5aCpqv2Gj3o51ioauelIiv
        3+GE9TAIfNLJgDr0z8Svl5daUywJbEdJbV8Tu+jwU+JRxMM3Z0ZHpfJ1LPz7sWi4pr+gtswIJnjHo
        pn98ukPr4Rf3dMhETFFg7SZgomKeaTlLwAYdJE3yVi0Re8EjW2AAQlrqMruKiMLl0915WfI7SfW5L
        vMQ9wGgdCwLrRLGVolJWE0PhVTZR7dL8AwSpnCiC0P6mas/VIrvPqwNer0jAc+pnPxWZIErA0ClDB
        uDShInt+71/7ZVg1VE65NPGS+Hp8pnSkgV0Qa4EBuejqOMy2kkgJLIfHvAg7NXZ1M45PvHk1mK6qx
        A8aAwh+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6RlT-009zaj-QO; Wed, 29 Jun 2022 07:05:31 +0000
Date:   Wed, 29 Jun 2022 00:05:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: factor the xfs_iunlink functions
Message-ID: <Yrv5uysZ54gX7bYj@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		*agibp,
>  	struct xfs_inode	*ip)
> -{
> + {

Whitespace damage here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
