Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23026183353
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgCLOkD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Mar 2020 10:40:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgCLOkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VRGwnTE4yP8ACy6DOYgmJwrZlmEMWfybXXxtQFzQGNg=; b=iXBwhl0wpl6XsEspui5HUZIHIj
        OvqxVPX6JMlyyaPVBwEHDPtumCWsUVh5wT9qQQXpboMxjkim+bh5yYtZ42TzVjvxUosm74RzT0h4e
        UTX2lFm4KE0sI9FBhSMMAMDQtKQLOKf3SuonO8rAVot5/kd5hWoPJGIfA7/YxmlvMYDxzZiQFsSic
        8pNrxgyTe84smETxQzYRtcad7a/dr9//EHOEZkPCYN6D4AXAb1muyO71pJxg3VxJNqCnwTwr1gM6C
        QjzlcTP9RfHWH4JPNtaHhPxHIDFlMr4nDrfa/65/+JM3kzkrBPkFUC79kreA+tTGliyvTsjLD2CKt
        y8UT0HYg==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCP0E-0006wB-1f; Thu, 12 Mar 2020 14:40:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: misc log cleanups
Date:   Thu, 12 Mar 2020 15:39:54 +0100
Message-Id: <20200312143959.583781-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains the simple and uncontroversial patches from the
"cleanup log I/O error handling", plus a few other trivial cleanups I
found while refactoring that series.
