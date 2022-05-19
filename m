Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C8652CE6E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 May 2022 10:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiESIg7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 May 2022 04:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiESIg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 04:36:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF635FF15
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 01:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lomdZGzXHnd2STK7Emc9p3aqbYUT+y2iQZlWB5/qY6Y=; b=463iI9XkwghNWwvEmRG5MGUb5I
        G4g774BpHpWJ6g8Uzc7ORfn7zcAjD1/L/PyxALYIeo+LbGG+yx58pY9x2AK0RQYQlz9BWHEotXhTu
        RIr5Ffn4UMQ1JwOl+aa3HS8RYcfoen/q4iLczqeR6rMO9p6AHVMmmnGqsvehaEV5zPrOvdVECkfCh
        1Mie+kbQEMs5uF6la+ghUo/eoq3FSJv73WrHZlItYyQzu9dwfYsWsfoterWGuCJgec5uLfVyA7aVx
        E/EM//PvXroeMEW5E5KVPgdwXA7gqFwfAn5zscyfXr1+GN+0fQNsDmJukcDmggTvUEL5UEadkqBiB
        cKYG7XKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbeT-005tnH-OC; Thu, 19 May 2022 08:36:57 +0000
Date:   Thu, 19 May 2022 01:36:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: convert buf_cancel_table allocation to
 kmalloc_array
Message-ID: <YoYBqe1I5fjl9Dfl@infradead.org>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290014021.1646290.13716646283504726941.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290014021.1646290.13716646283504726941.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:55:40AM -0700, Darrick J. Wong wrote:
> +	p = kmalloc_array(XLOG_BC_TABLE_SIZE, sizeof(struct list_head),
> +			GFP_KERNEL | __GFP_NOWARN);

Why the __GFP_NOWARN?
