Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE16D2F1AB9
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jan 2021 17:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbhAKQQ3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jan 2021 11:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730472AbhAKQQ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:16:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B42BC061786
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Anhh0plT21fXUIgL2+t+JDu1hQ24GQyTiFfculgINVo=; b=iJS6HEUXuSToGGy+jsigFwWqNK
        kPVTZzsNHGvOABtQSuLOyfFmjmQsNFvjryHtVC4fBxGJTI2YiwZO5I2tz53B4Z59U2vulsDoVNVcP
        Y96C9nOohHU6WwVp9vwv0UUNwAEx2at0QSSImNSdJ5MdJgEtk6x2qBbkisa36Habj2Wu6KBEI32N0
        TcaHc0cOxHYETBzJiKUghjxERkoe5jYcC8IllmDTQ2ZRdg0Xc6YQBa9AprGVVCfDD5HJ++v/d1gsg
        BgiabzY6NOqe7/2DziwY3xKfxm94smrN4ZZnZf1VdxDy6BtGGr4UgTC0LtRCgbQz4kMGLZojIRpO2
        f+I+EqOg==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzr6-003TmA-Tz
        for linux-xfs@vger.kernel.org; Mon, 11 Jan 2021 16:15:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: avoid taking the iolock in fsync unless actually needed
Date:   Mon, 11 Jan 2021 17:15:42 +0100
Message-Id: <20210111161544.1414409-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series avoids taking the iolock in fsync if there is no dirty
metadata.
