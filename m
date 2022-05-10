Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4F521131
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiEJJog (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 05:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiEJJof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:44:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BF81581A
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lgTwYXn9FRxuCJomJL6OsgbqsN
        J9CV1etX4nDST/Mnrq2/G74evbefOxx13meXGHTNZNM8la/f63HGxcxPxYnkzrRGIim14ymq+qZw5
        2ZJbZpLYeOwLA8uyeL4sDiXvTMeSePtfiA8CpNNGnRcW4l04PiilFe+UFhAUl51uIa/SoQmK2ZBrU
        Dq/zpFQN5ujbN2eZWj8H9qzDTLs8u6T2JLrTlTn3SdoYyYhvyn08uVVEROGF5EJ3HR5AJ10M52P1J
        98BAXWrxnk6RwDhxcm1SDvc2z576AsVwxW22DyArSwFpauTNGMz65eJ1laSsG0Rav4B+gpfJ7DCs1
        xrrepFLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMMA-000tzG-1S; Tue, 10 May 2022 09:40:38 +0000
Date:   Tue, 10 May 2022 02:40:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: report absolute maxlevels for each btree type
Message-ID: <YnozFjCHWImL8vfG@infradead.org>
References: <165176666861.247073.17043246723787772129.stgit@magnolia>
 <165176667978.247073.1336353301538627043.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176667978.247073.1336353301538627043.stgit@magnolia>
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

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
