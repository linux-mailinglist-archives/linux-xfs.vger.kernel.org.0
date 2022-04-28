Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8D51341E
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Apr 2022 14:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346639AbiD1MuE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Apr 2022 08:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346601AbiD1MuB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:50:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0AB2FFD1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uQbS88SvPX7zZQEfupJ1fM7q/L
        jDf/F/7VHHWdiWSoHuag0zxaz4kj0rQ0+nb3F4e4eN09p8cyGY0MbuaPqh5qBywCq7N3ZftCI+BbI
        n1UqtTwMgtyd1vyXlsCUTklpdqTpY/MDb4lC1DBwVd9NW5MdLd/FMaIIT32OMt3TSofpa/TEXmG1D
        0AMjffHGo5Gd3Hr4DW/AZZgf5bTruoGksJtz2mSlkwb14zxzOVhktZHmA0QOdGGhzUUqlUmsUDO9c
        +bCmlLQ/kPvC77PpKN49/AvXK2xG6aUVDnIzLZClIq3hePtlChj3ANo6HU+iQpCV4RURq9eskkpco
        ENNflJKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3Xg-006rhu-Gd; Thu, 28 Apr 2022 12:46:44 +0000
Date:   Thu, 28 Apr 2022 05:46:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: stop artificially limiting the length of bunmap
 calls
Message-ID: <YmqMtJ4c9YbMMkX/@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102072359.3922658.10110553526152188988.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102072359.3922658.10110553526152188988.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
