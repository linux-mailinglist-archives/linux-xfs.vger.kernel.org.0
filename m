Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38E5215F7
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbiEJMzy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 08:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbiEJMzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:55:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5494EA30
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TqucSDq5l7oH4GKXy9WV0ZkIHqd4+Zrobts4YX8Pt/I=; b=3lMwIT8dP2w/fgiip2bTPhZBPD
        XDIZxKtzpsGSAvVx9FBDduhCnKNDs1n7jArXLb+NyvpDJIlRfRULI7Cp/vjAGeRpm+2zQFc274n6i
        MuQ8FXfMx3DwRPOalHFx+ayUNaMJe33eHejLQyOeH1S5pOm9utsxWJG4ipD4X4nXdsXYNSJP+jqvU
        4Q6BUD6bbbRoyZ6zu2STleIdJi+CvNVf51L5k4dOMXO5N9QbqdXqeA7u3zQf5dyvETGVfpLPDgphN
        pPOjCKIkNWsBTIlMYyw8bPZwfXIXSpjSUO72btNPby0TiKveN1bqwvkztihFjVHFPAWporDKMPY0m
        q9g4pM3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPKX-0020xI-1u; Tue, 10 May 2022 12:51:09 +0000
Date:   Tue, 10 May 2022 05:51:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: fix sizing of the incore rt space usage
 map calculation
Message-ID: <YnpfvHb9Kwmpr3kp@infradead.org>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
 <165176668866.247207.345273533440446216.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176668866.247207.345273533440446216.stgit@magnolia>
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

On Thu, May 05, 2022 at 09:04:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If someone creates a realtime volume exactly *one* extent in length, the
> sizing calculation for the incore rt space usage bitmap will be zero
> because the integer division here rounds down.  Use howmany() to round
> up.  Note that there can't be that many single-extent rt volumes since
> repair will corrupt them into zero-extent rt volumes, and we haven't
> gotten any reports.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
