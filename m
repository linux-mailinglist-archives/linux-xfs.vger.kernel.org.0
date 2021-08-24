Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2733F5918
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Aug 2021 09:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhHXHgf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Aug 2021 03:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbhHXHge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 03:36:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6207C061575
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 00:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=DJzC90q4XFFX3LX3T0YSx1qJ5J
        ezrP8fxk1E8ALikGJLNJLmvJapu8W0idKeX7LeqaSdldWpzJqhwiPcHXLUHhfw7k0ZC4I0xQPdJZm
        uUJiWfNn58WTpI9WrGyYlJRUCx76RNenuODIX+X5RvJF3lqkMvzh1rnTmjvClQjT1MOUspHqX7wEp
        MvY7/0iZKhSVErPsvTS5F4mXuDLyIBz8KLBoe5TwK4N/6X9vyEoYI5so3bS3AgHJ/SC23PV+RHKab
        30H6pnlFhGvGRQVsHmoA7aH1iaw3dvI1wOU/04FEFhMubdENmCgy7J/7J8xi6X0V/yM9lPF5xSCwE
        AJ/FAOrg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIQxi-00Aiwr-Ti; Tue, 24 Aug 2021 07:35:22 +0000
Date:   Tue, 24 Aug 2021 08:35:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] generic: regression test for a FALLOC_FL_UNSHARE bug
 in XFS
Message-ID: <YSShLifGAdVpaYHr@infradead.org>
References: <20210824003739.GC12640@magnolia>
 <20210824003835.GD12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824003835.GD12640@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
