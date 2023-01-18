Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE7E671348
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 06:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjARFoF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Jan 2023 00:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjARFoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 00:44:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A854128;
        Tue, 17 Jan 2023 21:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eyOD/zdE3BC17ECECHXesBlDMX
        hB7CiEQdbrIrsktUHJdACBIWAX9dW74s31oV7FbpHJt7LA6myBTed8GIGhM69YLVxseCBwtXQck4m
        xKqOpAlgQI7eEnhBqVv2bhevBvn0W9oaO5wh844x7hcjK1Z+ay9P7LfGuOo54anaqi69XljSh7Jmj
        qiZYpQDy1d3pk0xQOyMSjeS4Jb6eWiVa+dotXEdS2IOukraIzkf0oCB0aTCKqVb+zg4kAfPCibNql
        5Sl2bNoZy5VR2cWs/p6nfGYVP3poPznCpRkqb4XimrCahn/BGftpLYI4NVAj+yZZEf1vbRZfPcvCH
        spiskYZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pI1Es-00H018-2l; Wed, 18 Jan 2023 05:43:58 +0000
Date:   Tue, 17 Jan 2023 21:43:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] various: test is not appropriate for always_cow mode
Message-ID: <Y8eHHtqIhz3XVdtV@infradead.org>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
 <167400102786.1914975.17542930173906194035.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400102786.1914975.17542930173906194035.stgit@magnolia>
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
