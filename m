Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6C5584608
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jul 2022 20:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiG1SmF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jul 2022 14:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiG1SmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:42:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0379174E0D;
        Thu, 28 Jul 2022 11:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ljpdsMKgiHn8Oxz5vq4UxTc72ItQ8b0zw23yrDU5ctg=; b=Qz/4g4ECqDjJGtxglH/xTxsdTN
        q/bIMi+yccKwORK3/8+/OWAVifmGms22mDsVOo7PMDw5jcXfQKpKlIiiHij6f4yCKrLVjkcfJbpDA
        ojKY1GSWkG2HUoVgntyDigYiuOpb06v6heChzQJa31H5z9hrePe6xoZInh03Et2e0xALzfmCiH58V
        6Ahdn/nPh2WX9vgzHyUeXJvhc+CeEmaBug+96SRWsuuOm6qXkyn4erqmXpLFFoXsQFOc813Wwkckc
        amUKvyE3RZikldqdQhpHPYAYXYIUPsp5WcdLWnjsT1F2v9R6zVrJuI9LLxGo1bho0D9IN5s+92Vgp
        23akZ+nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH8SJ-00DECe-43; Thu, 28 Jul 2022 18:41:55 +0000
Date:   Thu, 28 Jul 2022 11:41:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 1/2] common/rc: wait for udev before creating dm targets
Message-ID: <YuLYcwGwL3BrCIa2@infradead.org>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886491692.1585061.2529733779998396096.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886491692.1585061.2529733779998396096.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I have no idea what except for udev this could be, so if the patch
works for you:

Reviewed-by: Christoph Hellwig <hch@lst.de>
