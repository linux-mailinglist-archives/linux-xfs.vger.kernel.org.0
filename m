Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF0521130
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiEJJoS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 05:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbiEJJoO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:44:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80195299550
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qTLO+ovUg6gba8zNCpOLhxaJ4x
        LJLASj3b0QQLor07RGUmE6U3v5nmQDuqCUAHTpkShwNX/e6i+xKCTIn7ebwI0rtGq+5GcufOZkh38
        zQLoIa0V1S9Q9tPwYv8ij86G3ZXyNHJCQREPUT4pHs2L01xebasVTxXFOT6JNSNKzuHTgty7sLS7O
        mYGwqM1Kw+hUc3eGbyvrCRn08FzHwsi2crUyC1mV3HbJyEfYIjla4uG9vTeNXai/I6W8f++LSFi+/
        R2wkjr3yj858lLOf72D1qsTlE5Ass+5L91vIgH3oH99kYbCXZf70KCZwS1I8eOyjUhrVFeDuip1sb
        4IY3yt/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMLp-000tpY-43; Tue, 10 May 2022 09:40:17 +0000
Date:   Tue, 10 May 2022 02:40:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: support computing btheight for all cursor
 types
Message-ID: <YnozAdQtZdqlx0Hc@infradead.org>
References: <165176666861.247073.17043246723787772129.stgit@magnolia>
 <165176667420.247073.10421518802460549832.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176667420.247073.10421518802460549832.stgit@magnolia>
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
