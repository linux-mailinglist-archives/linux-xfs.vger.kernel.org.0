Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69FB20AEA2
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jun 2020 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFZJAf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Jun 2020 05:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgFZJAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 05:00:34 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACB4C08C5C1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2020 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aG+QD2UWIM76/5/EAI1SNRkNxT5D7lpbUjkqW12ez/U=; b=SpQB3u4RVE1oJZGsaL0POu6TMV
        QFsWETdEgTNLQDLC2dxF5vixV2NIxyqhLtx42ZdUDiY4aB2e3EjeXqGDSuPNIm5Zb2RxKbPNtmXgs
        Iru7koyPfQ082FKtYFIEgmm4JGMZPSgQA8Ci6bGsJm3MITj/ZwbeJ5ewWONXJwP5WgrA15rvTApU3
        w28wGj3srdHJHV6QfFnu/ij5WCvvvkqm+EpPl9Qzr5XixznfzTqfIlLvstAEIIlYWkUzaueSpx7PF
        N3uFAGaAi+iukGOohcOM/9TDw0wmBjXehcRhsg2viAC4hNpF5v9HM/cPMR5CZj3SjzvRGmPkCPhn1
        oIwj/rkw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jokDX-0008SC-Uh; Fri, 26 Jun 2020 09:00:16 +0000
Date:   Fri, 26 Jun 2020 10:00:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove useless definitions in xfs_linux.h
Message-ID: <20200626090015.GB30103@infradead.org>
References: <1593011328-10258-1-git-send-email-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593011328-10258-1-git-send-email-laoar.shao@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 11:08:48AM -0400, Yafang Shao wrote:
> Remove current_pid(), current_test_flags() and
> current_clear_flags_nested(), because they are useless.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
