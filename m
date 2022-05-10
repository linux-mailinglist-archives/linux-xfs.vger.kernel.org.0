Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42772521602
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbiEJM5z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 08:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241380AbiEJM5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:57:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800C7205451
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QAOxF6qB7BAQ72E/gb+5NelHrF
        SbzEzqE9ffHmdT+AiG2nhug7XCPpU45MgTdr6h8hEWek/Ia3uaStolq/IqAKhOxfX9fDTBQfKso96
        HJuAhXay670bflOWOiulNsoKRHd606BrLou9V5J6G17FTHpIW95wC2SGVON6WiVtGtnJO0h6vKpty
        IhZjTQsYTePLwqacW7sqq4LxHjWdxAnZGmcCAlFK57Fjg9gE4a8ag5yJDGCZYu3UyHtqWatZ+RDvb
        Yyjap1YAtOxHOUR4TILjCiplDaOMMYLUCkRYvZ4IK8AwPKr7P05KFTAuZ9e9t7OtKXj4x0Ya5gyhV
        R5ShKFHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPNB-00224E-82; Tue, 10 May 2022 12:53:53 +0000
Date:   Tue, 10 May 2022 05:53:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: check the rt bitmap against observations
Message-ID: <YnpgYWCm2ht3jJiu@infradead.org>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
 <165176669990.247207.2138416753332215196.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176669990.247207.2138416753332215196.stgit@magnolia>
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

